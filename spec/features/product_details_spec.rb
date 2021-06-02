
require 'rails_helper'

RSpec.feature "User goes from home page to a specific product details page", type: :feature, js: true do

  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "user clicks on a product and can see the product detail page" do
      # ACT
      visit root_path
      click_link('Details', :match => :first)
  
      # DEBUG
      sleep 1
      save_screenshot
  
      # VERIFY
      expect(page).to have_css 'article.product-detail'
    end
end 