class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: {result: true}, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:firstName, :lastName, :email, :password, :attachment)
  end

end