require 'rails_helper'

describe "When visitor goes to login page" do
  it "they can login and are directed to correct page" do
    user_1 = User.create(  name: "alec",
      address: "234 Main",
      city: "Denver",
      state: "CO",
      zip: 80204,
      email: "alec@gmail.com",
      password: "password"
    )

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"
    expect(current_path).to eq("/profile")
    expect(page).to have_content("Login in successful!")

  end
end
# As a visitor
# When I visit the login path
# I see a field to enter my email address and password
# When I submit valid information
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that I am logged in
