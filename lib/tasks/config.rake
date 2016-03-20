namespace :config do
  desc "Configurating app"
  task :development_environment do
    cp "config/database.yml.template", "config/database.yml"
    File.open("config/secrets.yml", "w") do |f|
      f.puts("development:\n  secret_key_base: " + `rake secret`)
    end
    `rake db:create db:migrate`
  end
end
