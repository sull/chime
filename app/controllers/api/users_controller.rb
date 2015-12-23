class Api::UsersController < ApplicationController
  before_action :prevent_if_logged_in, only: :create
  before_action :require_login, only: :update

  def create
    if User.friendly.exists?(params[:user][:username])
      render json: { errors: ["Username is not available"] }
      return
    end

    @user = User.new(user_params)

    if @user.save
      login!(@user)
      render "api/sessions/login"
    else
      render json: { errors: @user.errors.full_messages }
    end
  end

  def update
    username, password = current_user.username, user_params[:password]

    @user = User.find_by_credentials(username, password)

    if @user.nil?
      render json: { errors: ["Incorrect password"] }
      return
    end

    if @user.update(user_params.except(:password))
      render :show
    else
      render json: { errors: @user.errors.full_messages }
    end
  end

  def show
    @user = User.includes(:tracks).find_by(user: params[:id])

    return not_found if @user.nil?

    render :show
  end

  private

  def user_params
    attributes = [:username, :email, :password, :password_confirmation]
    params.require(:user).permit(*attributes)
  end
end
