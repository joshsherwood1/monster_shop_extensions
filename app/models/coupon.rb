class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates_presence_of :percent_off, :unless => :amount_off
  validates_presence_of :amount_off, :unless => :percent_off
  validates :enabled?, presence: true

  def shipped_orders_with_address?(id)
    self.user.orders.where(address_id: id).any?
  end
end
