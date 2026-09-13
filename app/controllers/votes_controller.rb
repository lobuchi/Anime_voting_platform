class VotesController < ApplicationController
  before_action :set_anime

  def create
    @vote = @anime.votes.find_or_initialize_by(user: Current.user)
    @vote.value = params[:score].to_i
    if @vote.save
      redirect_to @anime, notice: "Voted successfully!"
    else
      redirect_to @anime, alert: "Could not vote."
    end
  end

  def destroy
    @vote = @anime.votes.find_by(user: Current.user)
    @vote&.destroy
    redirect_to @anime, notice: "Vote removed."
  end

  private

  def set_anime
    @anime = Anime.find(params[:anime_id])
  end
end
