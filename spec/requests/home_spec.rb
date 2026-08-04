require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "uses the light theme" do
      get root_path

      expect(response.body).to include('<html data-theme="light">')
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/home/index"
      expect(response).to have_http_status(:success)
    end
  end
end
