class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  validates_inclusion_of :enabled?, :in => [true, false]


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    address_ids = item_orders.distinct.joins(:order).pluck(:address_id)
    addresses = Address.where(id: address_ids)
    addresses.map {|address| address.city}
  end

  def get_individual_orders
    item_orders.group(:order_id).select("item_orders.order_id, sum(quantity) as total_quantity, sum(quantity * item_orders.price) as total_subtotal").where(status: 0)
  end

  def toggle
    self.update(enabled?: !enabled?)
  end

  def activate_items
    items.update(active?: true)
  end

  def deactivate_items
    items.update(active?: false)
  end

end
