require 'spec_helper'

describe PasswordsController do
  describe "GET 'Passwords#new'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
    end

    it "loads successfully" do
      expect(response).to be_successful
    end

    it "renders the :new view" do
      expect(response).to render_template :new
    end
  end
end
