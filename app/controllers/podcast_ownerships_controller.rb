class PodcastOwnershipsController < ApplicationController
  before_action :authenticate_user!

  def new
    @podcast_ownership = PodcastOwnership.new
  end

  def create
  end

  def update
  end

  def destroy
    @podcast_ownership = PodcastOwnership.find(params[:id])
    @podcast_ownership.destroy
    redirect_to pod_path
  end
end