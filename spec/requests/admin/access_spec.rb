require 'spec_helper'

describe "Administrative Access" do
  include_context 'login'

  before do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin_user)
  end

  it "is not accessable to non-admin users" do
    log_in_with_user @user
    # Try to access admin area
    visit admin_dashboard_path
    expect(page).to have_content('Access denied')
    expect(page.status_code).not_to eq(200)
  end

  it "is accessable to admin users" do
    log_in_with_user @admin
    expect(current_path).to eq(admin_dashboard_path)
  end
end
