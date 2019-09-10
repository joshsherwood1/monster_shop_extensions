require 'rails_helper'

describe 'As an Admin' do
  before :each do
    @admin = User.create!(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 3)
    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    # @admin = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 3)
    visit '/login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button "Log In"
  end

  #conflicting user stories, need to revisit
  it 'I cannot visit any path starting with /merchant' do
    # binding.pry
    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end

  it 'I cannot visit any path for the shopping cart' do
    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
