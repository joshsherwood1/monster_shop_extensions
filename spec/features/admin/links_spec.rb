require 'rails_helper'

describe "As an Admin User" do
  before :each do
    @admin = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it "I see the same links as a regular user, a link to admin dashboard, and a link to show all users. I do not see a link to shopping cart." do
    visit '/login'
    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password
    click_button 'Log In'

    within 'nav' do
      expect(page).to have_link('All Merchants')
      expect(page).to have_link('All Items')
      expect(page).to have_link('Profile')
      expect(page).to have_link('Logout')
      expect(page).to have_link('Admin Dashboard')
      expect(page).to have_link('Users')
      expect(page).to_not have_link("Cart: 0")
    end
  end
end
