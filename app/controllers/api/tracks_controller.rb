class Api::TracksController < ApplicationController
  before_action :require_login, only: [:create, :update, :destroy]
  before_action :require_owner, only: [:update, :destroy]

  def index
    @tracks = Track.all.includes(:user)

    render :index
  end

  def create
    @track = current_user.tracks.new(track_params)

    if @track.save
      render :show
    else
      render json: { errors: @track.errors.full_messages }
    end
  end

  def update
    username, slug = params[:username], params[:id]
    @track = Track.find_by_username_and_slug(username, slug)

    return not_found if @track.nil?

    if @track.update(track_params)
      render :show
    else
      render json: { errors: @track.errors.full_messages }
    end
  end

  def show
    username, slug = params[:username], params[:id]
    @track = Track.find_by_username_and_slug(username, slug)

    return not_found if @track.nil?

    render :show
  end

  def destroy
    username, slug = params[:username], params[:id]
    @track = Track.find_by_username_and_slug(username, slug)

    return not_found if @track.nil?

    if @track.destroy
      render json: { success: ["Track deleted"] }
    else
      render json: { errors: @track.errors.full_messages }
    end
  end

  private

  def track_params
    params.require(:track).permit(:title, :description, :track_url, :img)
  end

  def require_owner
    track_owned = current_user.tracks.exists?(id: params[:id])

    forbidden unless track_owned
  end
end
