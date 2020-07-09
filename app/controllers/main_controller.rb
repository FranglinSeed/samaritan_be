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
    @tempRequests =  Request.where(status: true).all
    @requests = []
    @tempRequests.each do |request|
      @temp = {
          "id" => request.id,
          "userId" => request.user_id.to_s,
          "description" => request.description,
          "requestType" => request.requestType,
          "latitude" => request.latitude,
          "longitude" => request.longitude,
          "address" => request.address,
          "userName" => request.user.firstName + ' ' + request.user.lastName,
          "status" => request.status,
      }
      @requests.push(@temp)
    end
    render json: @requests, status: :ok
  end

  # Post /createMessage
  def createMessage
    @message_params = {
        "user_id" => params[:helperId],
        "content" => params[:content],
    }
    @message = Message.new(@message_params)
    if @message.save
      @conversation_params = {
          "request_id" => params[:requestId],
          "user_id" => params[:conversationUserId],
          'message_id' => @message.id
      }
      @conversation = Conversation.new(@conversation_params);
      if @conversation.save
        @conversations = Conversation.where(request_id: params[:requestId]).where(user_id: params[:conversationUserId]).all
        @messages = []
        @conversations.each do |conversation|
          @temp = {
              "userName" => conversation.message.user.firstName + ' ' + conversation.message.user.lastName,
              "content" => conversation.message.content,
          }
          @messages.push(@temp)
        end
        @request = Request.find_by_id(params[:requestId])
        @conversations = Conversation.where(request_id: params[:requestId]).where.not(user_id: @request.user_id).select('distinct(user_id)')
        if @conversations.length() > 4
          Request.where(id: params[:requestId]).update(:status => false)
        end
        render json: @messages, status: :created
      else
        render json: { errors: @conversation.errors.full_messages },
               status: :unprocessable_entity
      end
    else
      render json: { errors: @message.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # Post /getMessage
  def getMessage
    @conversations = Conversation.where(request_id: params[:requestId]).where(user_id: params[:conversationUserId]).all
    @messages = []
    @conversations.each do |conversation|
      @temp = {
          "userName" => conversation.message.user.firstName + ' ' + conversation.message.user.lastName,
          "content" => conversation.message.content,
      }
      @messages.push(@temp)
    end
    render json: @messages, status: :created
  end

  # Post /getHelper
  def getHelper
    @conversations = Conversation.where(request_id: params[:requestId]).where.not(user_id: params[:userId]).select('distinct(user_id)')
    @helpers = []
    @conversations.each do |conversation|
      @temp = {
          "userName" => conversation.user.firstName + ' ' + conversation.user.lastName,
          "userId" => conversation.user_id,
      }
      @helpers.push(@temp)
    end
    render json: @helpers, status: :created
  end

  # Post /getRequestUser
  def getRequestUser
    @requests = Conversation.select('distinct on (request_id) *')
    @users = []
    @requests.each do |request|
      @conversations = Conversation.where(request_id: request.request_id).where(user_id: params[:userId])
      @conversations.each do |conversation|
        if conversation.message.user.id.to_s != params[:userId]
          @temp = {
              "userName" => conversation.request.user.firstName + ' ' + conversation.request.user.lastName,
              "userId" => conversation.request.user_id,
              "requestId" => conversation.request.id
          }
          @users.push(@temp)
          break
        end
      end
    end
    render json: @users, status: :created
  end

  private

  def request_params
    params.require(:request).permit(:description, :requestType, :latitude, :longitude, :address, :user_id, :status )
  end

end
