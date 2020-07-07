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

  # Post /createConversation
  def createConversation
    @conversation_params = {
        "request_id" => params[:requestId],
        "user_id" => @current_user.id,
        "message" => params[:message],
    }
    @conversation =  Conversation.new(@conversation_params)
    if @conversation.save
      @conversations =  Conversation.where(request_id: params[:requestId]).all
      render json: @conversations, status: :created
    else
      render json: { errors: @conversation.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def request_params
    params.require(:request).permit(:description, :requestType, :latitude, :longitude, :address, :user_id, :status )
  end

  def conversation_params
    params.require(:conversation).permit(:request_id, :user_id, :message )
  end
end
