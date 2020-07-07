class MainController < ApplicationController
  before_action :authorize_request, except: %i[getRequests]

  # POST /createRequest
  def createRequest
    @request_params = {
        "description" => params[:description],
        "requestType" => params[:requestType],
        "latitude" => params[:latitude],
        "longitude" => params[:longitude],
        "address" => params[:address],
        "user_id" => @current_user.id,
        "status" => params[:status],
    }

    logger::info @request_params
    @request =  Request.new(@request_params)
    if @request.save
      render json: {result: true}, status: :created
    else
      render error: { error: 'Unable to create request.' }, status: 400
    end
  end

  # Get /getRequests
  def getRequests
    @requests =  Request.all
    render json: @requests, status: :ok
  end

  ## Post /createConversation
  #def createMessage
  #  @requests =  Request.all
  #  render json: @requests, status: :ok
  #end

  private

  def request_params
    params.require(:request).permit(:description, :requestType, :latitude, :longitude, :address, :user_id, :status )
  end

  #def conversation_params
  #  params.require(:conversation).permit(:request_id, :, :latitude, :longitude, :address, :user_id, :status )
  #end
end
