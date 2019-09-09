class User < ApplicationRecord
  has_secure_password

  has_many :orders
  belongs_to :merchant, optional: true

  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  #might want to downcase before save
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password_digest, require: true
  # validates :password_confirm, presence: true
  validates_length_of :zip, :is => 5
  validates_numericality_of :zip

  enum role: %w(regular_user merchant_employee merchant_admin admin )

  def no_orders?
    orders.empty?
  end

end
