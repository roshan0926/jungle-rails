require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    category1 = Category.create name: 'games'
    product1 = category1.products.create ({name: 'Overwatch', price: 30, quantity: 10000})

    it 'should ensure all fields are valid' do
      expect(product1).to be_valid
    end

    it 'validates if the name is present' do
      product1.name = nil
      expect(product1).to_not be_valid
    end

    it 'validates if the price is present' do
      product1.price = nil
      expect(product1).to_not be_valid
    end

    it 'validates if the quantity is present' do
      product1.quantity = nil
      expect(product1).to_not be_valid
    end

    it 'validates if the category is present' do
      category1.name = nil
      expect(product1).to_not be_valid
    end
  end
end