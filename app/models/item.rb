 class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, in: [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than_or_equal_to: 0

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def add(num)
    self.inventory += num
    save
  end

  def subtract(num)
    self.inventory -= num
    self.save
  end

  def toggle
    self.update(active?: !active?)
  end

  def self.most_popular_items
    joins(:item_orders).where(active?: true).group(:id).select("items.*, sum(quantity) as quantity_purchased").order("quantity_purchased DESC").limit(5)
  end

  def self.least_popular_items
    joins(:item_orders).where(active?: true).group(:id).select("items.*, sum(quantity) as quantity_purchased").order("quantity_purchased").limit(5)
  end

  def show_default_image
     self.image = "https://thumbs.dreamstime.com/b/coming-soon-neon-sign-brick-wall-background-87865865.jpg"
     self.save
  end
end
