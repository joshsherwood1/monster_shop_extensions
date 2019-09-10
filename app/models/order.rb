class Order <ApplicationRecord

  validates_presence_of :name, :address, :city, :state, :zip
  validates :status, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3}
  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def self.sort_orders
    order(status: :asc)
  end

end
