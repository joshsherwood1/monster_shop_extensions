require 'rails_helper'

describe 'Merchant Site Navigation' do
  describe "when merchant attempts to navigate to '/admin'" do
    it 'they will encounter a 404 error webpage' do
      merchant_employee = User.create(  name: "alec",
                          address: "234 Main",
                          city: "Denver",
                          state: "CO",
                          zip: 80204,
                          email: "alec@gmail.com",
                          password: "password",
                          role: 1)
      allow_any_instance_of(ApplicationController)
              .to receive(:current_user)
              .and_return(merchant_employee)

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

    end
  end
end
