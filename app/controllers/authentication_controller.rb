class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { accessToken: token, userName: @user.firstName + ' ' + @user.lastName }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # POST /createRequest
  def createRequest
    @request_params = {
        "description" => params[:description],
        "requestType" => params[:requestType],
        "latitude" => params[:latitude],
        "longitude" => params[:longitude],
        "address" => params[:address],
        "user_id" => @current_user.id
    }
    logger::info @request_params
    @request =  Request.new(@request_params)
    if @request.save
      render json: {result: true}, status: :created
    else
      render error: { error: 'Unable to create request.' }, status: 400
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  #def request_params
  #  params.require(:request).permit(:description, :requestType, :latitude, :longitude, :address, :user_id )
  #end

end