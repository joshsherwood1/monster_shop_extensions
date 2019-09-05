require 'rails_helper'

describe 'Visitor Site Navigation' do
  describe "when a visitor attempts to navigate to '/merchant' or '/admin'" do
    it 'they will encounter a 404 error webpage' do

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/profile"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

    end
  end
end
