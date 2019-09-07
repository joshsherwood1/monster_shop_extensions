require 'rails_helper'

describe 'User Site Navigation' do
  describe "when user attempts to navigate to '/merchant' or '/admin'" do
    it 'they will encounter a 404 error webpage' do
      regular_user = User.create(  name: "alec",
                          address: "234 Main",
                          city: "Denver",
                          state: "CO",
                          zip: 80204,
                          email: "alec@gmail.com",
                          password: "password",
                          role: 0)
      allow_any_instance_of(ApplicationController)
              .to receive(:current_user)
              .and_return(regular_user)

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

    end
  end

  describe "when user attempts to navigate to '/profile', '/cart', '/items', or '/merchants/'" do
    it 'they can do so' do
      regular_user = User.create(  name: "alec",
                          address: "234 Main",
                          city: "Denver",
                          state: "CO",
                          zip: 80204,
                          email: "alec@gmail.com",
                          password: "password",
                          role: 0)
      allow_any_instance_of(ApplicationController)
              .to receive(:current_user)
              .and_return(regular_user)

      visit "/merchants"
      expect(current_path).to eq("/merchants")

      visit "/profile"
      expect(current_path).to eq("/profile")

      visit "/items"
      expect(current_path).to eq("/items")

      visit "/cart"
      expect(current_path).to eq("/cart")

    end
  end
end
