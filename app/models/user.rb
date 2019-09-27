class User < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :addresses
  belongs_to :merchant, optional: true
  accepts_nested_attributes_for :addresses
  validates_associated :addresses

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password_digest, require: true

  enum role: %w(regular_user merchant_employee merchant_admin admin )

  def no_orders?
    orders.empty?
  end

  def no_addresses?
    addresses.empty?
  end

  def addresses_except_order_address(order_address_id)
    self.addresses.where.not(id: order_address_id)
  end

end
