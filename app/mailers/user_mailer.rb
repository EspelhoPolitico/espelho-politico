class UserMailer < ActionMailer::Base
	default from: 'espelho.politico@gmail.com', 'Content-Transfer-Encoding' => '7bit'

  def complaint_about_proposition(user, parliamentarian, proposition)
    @user = User.find(user)
    @parliamentarian = Parliamentarian.find(parliamentarian)
    @proposition = Proposition.find(proposition)
    mail(to: @parliamentarian.email, subject: "Reclamação sobre identificação da #{@proposition.proposition_types} #{@proposition.number}/#{@proposition.year}")
  end
end
