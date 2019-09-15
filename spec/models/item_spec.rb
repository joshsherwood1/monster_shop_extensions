require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @user = User.create!(  name: "alec",
        email: "alec@gmail.com",
        password: "password"
      )
      @address_home = @user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)

      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = @user.orders.create(address_id: @address_home.id)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2, merchant_id: @bike_shop.id)
      expect(@chain.no_orders?).to eq(false)
    end

    it "adds order quantity to item inventory" do
      @itemorder = ItemOrder.create(item_id: @chain.id, quantity: 2, price: 100, merchant_id: @bike_shop.id)
      @chain.add(@itemorder.quantity)
      expect(@chain.inventory).to eq(7)
    end

    it "subtract order quantity from item inventory" do
      @itemorder = ItemOrder.create(item_id: @chain.id, quantity: 2, price: 100, merchant_id: @bike_shop.id)
      @chain.subtract(@itemorder.quantity)
      expect(@chain.inventory).to eq(3)
    end

    it "toggles" do
      expect(@chain.active?).to eq(true)
      @chain.toggle
      expect(@chain.active?).to eq(false)
      @chain.toggle
      expect(@chain.active?).to eq(true)
    end
  end

  describe "class methods" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @paper = @bike_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @helmet = @meg.items.create(name: "Helmet", description: "Regular helmet", price: 50, image: "https://www.revzilla.com/product_images/0070/3821/shoei_rf1200_helmet_solid_matte_black_300x300.jpg", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @pink_helmet = @meg.items.create(name: "Pink Helmet", description: "Very pink helmet!", price: 51, image: "https://images-na.ssl-images-amazon.com/images/I/716FdxJKkjL._SX425_.jpg", inventory: 12)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @regular_user =  User.create!(  name: "alec",
                      email: "5@gmail.com",
                      password: "password"
                    )
      @address_home_2 = @regular_user.addresses.create!(address: "1600 Pennsylvania Ave NW", city: "Washington", state: "DC", zip: 20500)

      @order_1 = @regular_user.orders.create(address_id: @address_home_2.id)
      @order_2 = @regular_user.orders.create(address_id: @address_home_2.id)
      @order_3 = @regular_user.orders.create(address_id: @address_home_2.id)
      @itemorder = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, quantity: 2, price: 100, merchant_id: @meg.id)
      @itemorder_2 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, quantity: 1, price: 20, merchant_id: @bike_shop.id)
      @itemorder_3 = ItemOrder.create(order_id: @order_1.id, item_id: @pink_helmet.id, quantity: 3, price: 51, merchant_id: @meg.id)
      @itemorder_4 = ItemOrder.create(order_id: @order_2.id, item_id: @pull_toy.id, quantity: 4, price: 10, merchant_id: @bike_shop.id)
      @itemorder_5 = ItemOrder.create(order_id: @order_2.id, item_id: @helmet.id, quantity: 3, price: 50, merchant_id: @meg.id)
      @itemorder_6 = ItemOrder.create(order_id: @order_3.id, item_id: @pencil.id, quantity: 72, price: 2, merchant_id: @bike_shop.id)
      @itemorder_7 = ItemOrder.create(order_id: @order_3.id, item_id: @pink_helmet.id, quantity: 5, price: 51, merchant_id: @meg.id)
    end

    it "sorts top 5 items based on most quantity ordered" do
      expect(Item.most_popular_items).to eq([@pencil, @pink_helmet, @pull_toy, @helmet, @tire])
    end

    it "sorts top 5 items based on least quantity ordered" do
      expect(Item.least_popular_items).to eq([@paper, @tire, @helmet, @pull_toy, @pink_helmet])
    end

    it "adds image if no image is given in new item creation form" do
      @green_helmet = @meg.items.create(name: "Pink Helmet", description: "Very pink helmet!", price: 51, inventory: 12)
      @green_helmet.show_default_image
      expect(@green_helmet.image).to eq("https://thumbs.dreamstime.com/b/coming-soon-neon-sign-brick-wall-background-87865865.jpg")
    end
  end
end
