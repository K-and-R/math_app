require 'spec_helper'

describe HomeController do
  describe "GET 'Home#index'" do
    before :each do
      get 'index'
    end
    it "loads successfully" do
      expect(response).to be_successful
    end
    it "renders the :index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET 'Home#about'" do
    before :each do
      get 'about'
    end
    it "loads successfully" do
      expect(response).to be_successful
    end
    it "renders the :about view" do
      expect(response).to render_template :about
    end
  end

  describe "GET 'Home#contact'" do
    before :each do
      get 'contact'
    end
    it "loads successfully" do
      get 'contact'
      expect(response).to be_successful
    end
    it "renders the :contact view" do
      expect(response).to render_template :contact
    end
  end

  describe "GET 'Home#privacy'" do
    before :each do
      get 'privacy'
    end
    it "loads successfully" do
      get 'privacy'
      expect(response).to be_successful
    end
    it "renders the :privacy view" do
      expect(response).to render_template :privacy
    end
  end

  describe "GET 'Home#terms'" do
    before :each do
      get 'terms'
    end
    it "loads successfully" do
      get 'terms'
      expect(response).to be_successful
    end
    it "renders the :terms view" do
      expect(response).to render_template :terms
    end
  end

  describe "GET 'Home#help'" do
    before :each do
      get 'help'
    end
    it "loads successfully" do
      get 'help'
      expect(response).to be_successful
    end
    it "renders the :help view" do
      expect(response).to render_template :help
    end
  end
end
