class QuizController < ApplicationController
  def initialize
    @proposition_hold = Proposition.all.where.not(explanation: "\n ").to_a
    @proposition_hold = @proposition_hold.map { |p| p.id }
    super
  end

  def index
  end

  def create
    if (params[:vote] && params[:vote].require(:approved?) != "Pular")
      Vote.create(vote_params)
    end

    remover_proposicoes_votadas(current_user.id)

    if (@proposition_hold.empty?)
      @proposition = nil
    else
      @proposition = randomize_propositions(@proposition_hold)
    end
  end

  def randomize_propositions(propositions)
    propositions = propositions.sort_by { rand }
    Proposition.find_by(id: propositions[0])
  end

  def remover_proposicoes_votadas(user)
    votos = Vote.where(user_id: user)
    votos.each do |v|
      @proposition_hold.delete_at(@proposition_hold.index(v.proposition_id))
    end
  end

  private
    def vote_params
      params.require(:vote).permit(:user_id, :proposition_id, :approved?)
    end
end
