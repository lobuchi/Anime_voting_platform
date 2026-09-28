class WatchStatusesController < ApplicationController
  before_action :set_anime
  before_action :set_watch_status, only: [:update, :destroy]

  def create
    @watch_status = Current.user.watch_statuses.find_or_initialize_by(anime: @anime)
    @watch_status.status = params[:status]

    if @watch_status.save
      redirect_to @anime, notice: "Added to your list."
    else
      redirect_to @anime, alert: @watch_status.errors.full_messages.to_sentence
    end
  end

  def update
    if @watch_status.update(status: params[:status])
      redirect_to @anime, notice: "Status updated."
    else
      redirect_to @anime, alert: "Could not update status."
    end
  end

  def destroy
    @watch_status.destroy
    redirect_to @anime, notice: "Removed from your list."
  end

  private

  def set_anime
    @anime = Anime.find(params[:anime_id])
  end

  def set_watch_status
    @watch_status = Current.user.watch_statuses.find_by!(anime: @anime)
  end
end
