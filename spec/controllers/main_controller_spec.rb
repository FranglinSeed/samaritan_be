require "rails_helper"

RSpec.describe MainController, :type => :controller do
  describe "responds to custom formats" do
    it "creates a Request" do
      post :createRequest, :params => { :request => { :userId => 1, :description => "MyString", :requestType => "MyString", :latitude => 1.5, :longitude => 1.5, :address => "MyString", :status => false }, :format => :json }
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end
  end

  describe "responds to custom formats" do
    it "get Requests" do
      post :getRequests
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end
  end

  describe "responds to custom formats" do
    it "crete a Message" do
      post :createMessage, :params => { :request => { :helperId => 1, :content => "MyString" }, :format => :json }
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end
  end

  describe "responds to custom formats" do
    it "get Messages" do
      post :getMessage, :params => { :request => { :requestId => 1, :conversationUserId => 1 }, :format => :json }
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end
  end

  describe "responds to custom formats" do
    it "get Helpers" do
      post :getHelper, :params => { :request => { :requestId => 1, :userId => 1 }, :format => :json }
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end
  end

  describe "responds to custom formats" do
    it "get RequestUsers" do
      post :getRequestUser, :params => { :request => { :userId => 1 }, :format => :json }
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end
  end
end