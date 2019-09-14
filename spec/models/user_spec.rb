require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:email)}
    it {should validate_uniqueness_of(:email)}
    it {should validate_presence_of(:password)}
  end

  describe "relationships" do
    it {should have_many :orders}
    it {should have_many :addresses}
  end

  describe "roles" do
    it "can be created as a default user" do
      user = User.create!(name: "alec",
                        address: "123 Main",
                        city: "Denver",
                        state: "CO",
                        zip: 80222,
                        email: "623@gamil.com",
                        password: "password",
                        role: 0)

      expect(user.role).to eq("regular_user")
      expect(user.regular_user?).to be_truthy
    end

    it "can be created as a merchant_employee" do
      user = User.create(name: "alec",
                        address: "123 Main",
                        city: "Denver",
                        state: "CO",
                        zip: 80222,
                        email: "823@gamil.com",
                        password: "password",
                        role: 1)

      expect(user.role).to eq("merchant_employee")
      expect(user.merchant_employee?).to be_truthy
    end
  end

  describe "instance methods" do
    it "can verify that a user has no orders" do
    user = User.create!(name: "alec",
                      address: "123 Main",
                      city: "Denver",
                      state: "CO",
                      zip: 80222,
                      email: "456@gamil.com",
                      password: "password",
                      role: 0)
    expect(user.no_orders?).to eq(true)
    end
  end
end
