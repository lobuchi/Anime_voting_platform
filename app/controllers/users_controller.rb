class UsersController < ApplicationController
  allow_unauthenticated_access only: :show
  before_action :resume_session, only: :show

  def show
    @user     = User.find_by!(username: params[:id])
    @votes    = @user.votes.includes(:anime).recent.limit(20)
    @comments = @user.comments.includes(:anime).recent.limit(20)
  end
end
