require "rails_helper"

RSpec.describe UsersController, :type => :controller do
  describe "responds to custom formats" do
    it "create a User" do
      post :create, :params => { :user => { :fistName => "Test", :lastName => "Software", :email => "test@gmail.com", :password => "123456" }, :format => :json }
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end
  end
end