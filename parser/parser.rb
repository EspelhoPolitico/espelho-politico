require 'savon'
require 'mysql2'
require 'rails'

initial_time = Time.now

db_host = "localhost"
db_name = ARGV[0]
db_user = ARGV[1]

begin
  db_pwd = ARGV[2]
rescue
  db_pwd = ""
end

db = Mysql2::Client.new(:host => db_host, :username => db_user, :password => db_pwd, :database => db_name)

client = Savon.client do
  wsdl "http://www.camara.gov.br/SitCamaraWS/Deputados.asmx?WSDL"
  open_timeout 10
  read_timeout 10
  log false
end

response = client.call(:obter_deputados)

parliamentarians = response.body[:obter_deputados_response][:obter_deputados_result][:deputados][:deputado]

puts parliamentarians.count.to_s + " parlamentares encontrados!"

client = Savon.client do
  wsdl "http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx?WSDL"
  open_timeout 10
  read_timeout 10
  log false
end

proposition_types = ['PL', 'PLC', 'PLN', 'PLP', 'PLS', 'PLV', 'EAG', 'EMA',
            'EMC', 'EMC-A', 'EMD', 'EML', 'EMO', 'EMP', 'EMPV',
            'EMR', 'EMRP', 'EMS', 'EPP', 'ERD', 'ERD-A', 'ESB',
            'ESP', 'PEC', 'PDS', 'PDN', 'PDC']

parliamentarians.each do |p|
  id = p[:ide_cadastro]
  condition = p[:condicao]
  registry = p[:matricula]
  civil_name = p[:nome].to_s.gsub("'", "''").mb_chars.titleize
  name = p[:nome_parlamentar].to_s.gsub("'", "''").mb_chars.titleize
  url_photo = p[:url_foto]
  state = p[:uf]
  party = p[:partido]
  cabinet = p[:gabinete]
  phone = p[:fone]
  email = p[:email]

  puts
  puts "Obtendo proposições de " + "#{name}"

  begin
    insert = db.query("INSERT INTO parliamentarians VALUES (#{id}, '#{condition}',
     '#{registry}', '#{civil_name}', '#{name}', '#{url_photo}', '#{state}',
      '#{party}', '#{cabinet}', '#{phone}', '#{email}')") 
  rescue
    puts name.to_s + " já cadastrado"
  end

  proposition_types.each do |t|
    begin
      response = client.call(:listar_proposicoes) do
        message( sigla: t,  parteNomeAutor: name )
      end

      propositions =  response.body[:listar_proposicoes_response][:listar_proposicoes_result][:proposicoes][:proposicao]
      propositions.each do |pr|
        pr_id = pr[:id]
        proposition_type = t
        number = pr[:numero]
        year = pr[:ano]
        presentation_date = pr[:dat_apresentacao].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
        amendment = pr[:txt_ementa]
        explanation = pr[:txt_explicacao_ementa]
        parliamentarian_id = pr[:autor1][:idecadastro]
        situation = pr[:situacao][:descricao]

        response = client.call(:obter_proposicao_por_id) do
          message( idProp: pr_id )
        end

        extra_information = response.body[:obter_proposicao_por_id_response][:obter_proposicao_por_id_result][:proposicao]

        content_link = extra_information[:link_inteiro_teor]
        themes = extra_information[:tema].split('; ')

        begin
          insert = db.query("INSERT INTO propositions VALUES (#{pr_id}, '#{proposition_type}',
           #{number}, #{year}, '#{presentation_date}', '#{amendment}', '#{explanation}',
            '#{situation}', '#{content_link}', #{parliamentarian_id})")
        rescue
          puts "Proposição " + pr_id + " já cadastrada."
        end

        themes.each do |th|
          begin
            insert = db.query( "INSERT INTO themes (description) VALUES ('#{th}')" )
          rescue
            puts "Tema " + th + " já cadastrado."
          end

          begin
            th_id = db.query( "SELECT id from themes WHERE (description = '#{th}')" ).to_a[0]["id"]
            insert = db.query( "INSERT INTO propositions_themes VALUES (#{pr_id}, #{th_id})" )
          rescue
            puts "Relacionamento Tema-Proposição já existente"
          end
        end
      end
    rescue
      puts "Parlamentar sem proposição de " + t.to_s
    end
  end
end

db.close

final_time = Time.now
time_spent = Time.parse(final_time.to_s) - Time.parse(initial_time.to_s)

puts "", "O parser levou: " + (time_spent/3600%24).to_int.to_s + "h" + ((time_spent/60)%60).to_int.to_s + "min e " + (time_spent%60).to_int.to_s + "seg para ser concluído!"
