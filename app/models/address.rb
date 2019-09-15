class Address < ApplicationRecord
  belongs_to :user
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates_length_of :zip, :is => 5
  validates_numericality_of :zip
  validates :address_type, presence: true

  def shipped_orders_with_address?(id)
    self.user.orders.where(address_id: id).where(status: 2).any?
  end
end
