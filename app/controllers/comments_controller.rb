class CommentsController < ApplicationController
  before_action :set_anime

  def create
    @comment = @anime.comments.build(comment_params)
    @comment.user = Current.user
    if @comment.save
      redirect_to @anime, notice: "Comment added."
    else
      redirect_to @anime, alert: "Could not add comment."
    end
  end

  def destroy
    @comment = @anime.comments.find(params[:id])
    if @comment.user == Current.user || Current.user.admin?
      @comment.destroy
      redirect_to @anime, notice: "Comment deleted."
    else
      redirect_to @anime, alert: "Not authorized."
    end
  end

  private

  def set_anime
    @anime = Anime.find(params[:anime_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
