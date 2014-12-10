class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :products

  def price
    products.sum(:price).to_f
  end
end
