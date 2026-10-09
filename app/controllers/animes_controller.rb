class AnimesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]
  before_action :resume_session, only: [:index, :show]
  before_action :set_anime, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:edit, :update, :destroy]

  def index
    @animes = Anime.order(score: :desc, created_at: :desc)
    @animes = @animes.where("title ILIKE ?", "%#{params[:q]}%") if params[:q].present?
  end

  def show
    @comments     = @anime.comments.includes(:user).order(created_at: :desc)
    @vote         = Current.user ? @anime.votes.find_by(user: Current.user) : nil
    @watch_status = Current.user ? Current.user.watch_statuses.find_by(anime: @anime) : nil
  end

  def new
    @anime = Anime.new
  end

  def create
    @anime = Anime.new(anime_params)
    @anime.score = 0
    if @anime.save
      redirect_to @anime, notice: "Anime was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @anime.update(anime_params)
      redirect_to @anime, notice: "Anime was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @anime.destroy
    redirect_to animes_path, notice: "Anime was deleted."
  end

  private

  def set_anime
    @anime = Anime.find(params[:id])
  end

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "Not authorized. Only admins can delete."
    end
  end

  def anime_params
    params.require(:anime).permit(:title, :description, :image_file, :trailer_url, :airing_status)
  end
end
