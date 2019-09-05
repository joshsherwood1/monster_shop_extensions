require 'rails_helper'
describe "When a user logs out" do
  it "they are redirected to the home page, see a flash message indicating they are logged out, and their shopping cart has been cleared" do
    user = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit '/items'
    within 'nav' do
      expect(page).to have_content("Cart: 1")
    end
    expect(page).to have_content("Logged in as #{user.name}")
    click_link("Logout")
    expect(current_path).to eq("/")
    expect(page).to have_content("You have been logged out.")
    within 'nav' do
      expect(page).to have_content("Cart: 0")
    end
    visit "/cart"
    expect(page).to have_content("Cart is currently empty")
    expect(page).to have_link("Login")
    expect(page).to have_link("Register")
    expect(page).to_not have_link("Profile")
    expect(page).to_not have_link("Logout")
    expect(page).to_not have_content("Logged in as #{user.name}")
    within 'nav' do
      expect(page).to have_content("Cart: 0")
    end
    visit "/cart"
    expect(page).to have_content("Cart is currently empty")
  end
end
