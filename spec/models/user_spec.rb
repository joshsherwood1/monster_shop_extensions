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
                        email: "623@gamil.com",
                        password: "password",
                        role: 0)
      expect(user.role).to eq("regular_user")
      expect(user.regular_user?).to be_truthy
    end

    it "can be created as a merchant_employee" do
      user = User.create(name: "alec",
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
                      email: "456@gamil.com",
                      password: "password",
                      role: 0)
    expect(user.no_orders?).to eq(true)
    end

    it "can verify that a user has no addresses" do
      @user = User.create(name: 'Christopher', email: 'christopher678@email.com', password: 'p@ssw0rd', role: 0)
      expect(@user.no_addresses?).to eq(true)
      @address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)
      expect(@user.no_addresses?).to eq(false)
    end

    it "can show addresses that are not part of a specific order" do
      @regular_user_3 = User.create!(  name: "alec", email: "56955@gmail.com", password: "password")
      @address_7 = @regular_user_3.addresses.create!(address: "234 Main", city: "Denver", state: "CO", zip: 80204)
      @address_8 = @regular_user_3.addresses.create!(address: "987 Evergreen Dr", city: "Seattle", state: "WA", zip: 74132, address_type: "Work")
      @order_2 = @regular_user_3.orders.create!(address_id: @address_7.id, status: 1)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      ItemOrder.create!(merchant_id: @meg.id, item_id: @tire.id, price: 100, quantity: 1, order_id: @order_2.id)
      expect(@regular_user_3.addresses_except_order_address(@address_7.id)).to eq([@address_8])
    end
  end
end
