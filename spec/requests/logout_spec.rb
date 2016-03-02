require 'spec_helper'

describe 'Logout' do
  include_context 'login'
  include_context 'registration'

  before do
    @user = FactoryGirl.build(:user)
  end

  it 'loads (HTTP 302)' do
    get logout_path
    expect(response.status).to be(302)
  end

  it 'is accessable without login' do
    get logout_path
    expect(response.status).not_to be(403)
  end

  it 'redirects to login_path after successfully logging out' do
    get logout_path
    expect(response.status).to be(302)
    expect(current_path).to redirect_to(login_path)
  end

  it 'redirects to login_path with "Signed out" message' do
    visit logout_path
    expect(current_path).to eq(login_path)
    expect(page).to have_content('Signed out successfully.')
  end
end

