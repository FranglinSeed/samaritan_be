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
    @requests =  Request.where(status: true).all
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
      @tempConversations =  Conversation.where(request_id: params[:requestId]).all
      @conversations = []
      @tempConversations.each do |conversation|
        @temp = {
            "id" => conversation.id,
            "requestId" => conversation.request_id,
            "userId" => conversation.user_id,
            "userName" => conversation.user.firstName + ' ' + conversation.user.lastName,
            "message" => conversation.message,
        }
        @conversations.push(@temp)
      end
      @userCount = Conversation.where(request_id: params[:requestId]).distinct.count(:user_id)
      if @userCount > 4
        Request.where(id: params[:requestId]).update(:status => false)
      else
        logger::info @userCount
      end
      render json: @conversations, status: :created
    else
      render json: { errors: @conversation.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # Post /getConversation
  def getConversation
    @tempConversations =  Conversation.where(request_id: params[:requestId]).all
    @conversations = []
    @tempConversations.each do |conversation|
      @temp = {
          "id" => conversation.id,
          "requestId" => conversation.request_id,
          "userId" => conversation.user_id,
          "userName" => conversation.user.firstName + ' ' + conversation.user.lastName,
          "message" => conversation.message,
      }
      @conversations.push(@temp)
    end
    render json: @conversations, status: :created
  end

  private

  def request_params
    params.require(:request).permit(:description, :requestType, :latitude, :longitude, :address, :user_id, :status )
  end

  def conversation_params
    params.require(:conversation).permit(:request_id, :user_id, :message )
  end
end
