require 'rails_helper'

RSpec.describe "User Profile" do
  describe "As a registered user" do
    before :each do
      @user = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @user_2 = User.create(name: 'Christopher', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021, email: 'ck@email.com', password: 'p@ssw0rd', role: 0)
    end

    it 'I visit my profile page and see all my profile data except my password. I see a link to edit my profile data.' do
      visit '/profile'

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit Profile')
    end

    it 'I click the Edit Profile link. I see a prepopulate form with my current info. I submit the form and am returned to my profile page with my new info.' do
      visit '/profile'
      click_link 'Edit Profile'
      expect(current_path).to eq('/profile/edit')

      expect(find_field(:name).value).to eq(@user.name)
      expect(find_field(:address).value).to eq(@user.address)
      expect(find_field(:city).value).to eq(@user.city)
      expect(find_field(:state).value).to eq(@user.state)
      expect(find_field(:zip).value).to eq(@user.zip.to_s)
      expect(find_field(:email).value).to eq(@user.email)

      name = 'Christopher'
      address = '456 1st St'
      city = 'Northglenn'
      state = 'CO'
      zip = 80233
      email = 'christopher@email.com'

      fill_in "Name", with: name
      fill_in "Email", with: email
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      click_button 'Update Profile'

      expect(current_path).to eq('/profile')

      expect(page).to have_content('Your profile has been updated')
      expect(page).to have_content(name)
      expect(page).to have_content(address)
      expect(page).to have_content(city)
      expect(page).to have_content(state)
      expect(page).to have_content(zip)
      expect(page).to have_content(email)
    end

    it 'I see a link to edit my password. I fill out the form and am returned to my profile. I see a flash message confirming the update.' do
      visit '/profile'
      click_link 'Edit Password'

      expect(current_path).to eq('/profile/password_edit')

      password = 'password'
      password_confirmation = 'password'

      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation

      click_button 'Submit'

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Your password has been updated')
    end

    it 'I must use a unique email address when updating my profile' do
      visit '/profile/edit'

      email = 'ck@email.com'

      fill_in "Email", with: email
      click_button 'Update Profile'

      expect(current_path).to eq('/profile/edit')
      expect(page).to have_content("Email has already been taken")
    end
  end
end
