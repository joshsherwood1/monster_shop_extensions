require 'rails_helper'

describe "As an Admin User" do
  before :each do
    @admin = User.create(name: 'Christopher', email: 'christopher678@email.com', password: 'p@ssw0rd', role: 3)
    @address_2 = @admin.addresses.create!(address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021)
    @user_1 = User.create!(  name: "alec", email: "5@gmail.com", password: "password")
    @user_2 = User.create!(  name: "josh", email: "6@gmail.com", password: "password", role: 1)
    @user_3 = User.create!(  name: "josh", email: "7@gmail.com", password: "password", role: 1)
    @address_3 = @user_2.addresses.create(address: "789 Main", city: "Lakewood", state: "CO", zip: 80204)
    @address_4 = @user_1.addresses.create(address: "111 Main", city: "Castle Rock", state: "CO", zip: 80204)
    @address_5 = @user_3.addresses.create(address: "389 Main", city: "Telluride", state: "CO", zip: 80204)
    @address_6 = @user_3.addresses.create(address: "567 Mountain St", city: "Durango", state: "CO", zip: 80204)

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button "Log In"
  end

  it "I can see all the users in the system" do

    visit '/'
    click_link("Users")

    expect(current_path).to eq("/admin/users")
    within "#user-index-#{@user_1.id}" do
      expect(page).to have_content(@user_1.name)
      expect(page).to have_content("Date registered: #{@user_1.created_at}")
      expect(page).to have_content("User type: #{@user_1.role}")
      click_link("#{@user_1.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_1.id}")

    visit '/admin/users'
    within "#user-index-#{@user_2.id}" do
      expect(page).to have_content(@user_2.name)
      expect(page).to have_content("Date registered: #{@user_2.created_at}")
      expect(page).to have_content("User type: #{@user_2.role}")
      click_link("#{@user_2.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_2.id}")

    visit '/admin/users'
    within "#user-index-#{@user_3.id}" do
      expect(page).to have_content(@user_3.name)
      expect(page).to have_content("Date registered: #{@user_3.created_at}")
      expect(page).to have_content("User type: #{@user_3.role}")
      click_link("#{@user_3.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_3.id}")
  end

  it "I can see user profile page" do
    visit("/admin/users/#{@user_3.id}")
    expect(page).to have_content(@user_3.name)
    expect(page).to have_content(@address_5.address_type)
    expect(page).to have_content(@address_5.address)
    expect(page).to have_content(@address_5.city)
    expect(page).to have_content(@address_5.state)
    expect(page).to have_content(@address_5.zip)
    expect(page).to have_content(@address_6.address_type)
    expect(page).to have_content(@address_6.address)
    expect(page).to have_content(@address_6.city)
    expect(page).to have_content(@address_6.state)
    expect(page).to have_content(@address_6.zip)
    expect(page).to have_content(@user_3.email)
    expect(page).to_not have_content(@user_3.password)
    expect(page).to_not have_link('Edit Profile')
  end
end
