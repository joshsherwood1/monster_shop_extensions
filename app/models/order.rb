class Order <ApplicationRecord

  validates :status, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3}
  belongs_to :user
  belongs_to :address
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def packaged
    self.status = 1
    self.save
  end

  def shipped
    self.status = 2
    self.save
  end

  def self.sort_orders
    order(status: :asc)
  end

  def all_item_orders_fulfilled?
    self.item_orders.pluck(:status).all? { |status| status == "fulfilled"}
  end

  def show_order(id)
      self.item_orders.select("item_orders.*").where("merchant_id = #{id}")
  end

  def cancel_order
    self.item_orders.each do |item_order|
      item_order[:status] = "unfulfilled"
      item = Item.find(item_order.item_id)
      item.add(item_order.quantity)
    end
    self.update(status: 3)
  end
end
