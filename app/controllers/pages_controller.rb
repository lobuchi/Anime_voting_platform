class PagesController < ApplicationController
  allow_unauthenticated_access only: [:about, :privacy]
  before_action :resume_session, only: [:about, :privacy]

  def about
  end

  def privacy
  end
end
