# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartService do
  let(:user) { build(:user) }
  let(:service) { CartService.new(user) }

  let(:expect_values) do
    {
      apple: 60,
      banana: 10,
      orange: 120
    }
  end

  context 'when cart receive negative amounts' do
    let(:expect_values) do
      {
        apple: 0,
        banana: 0,
        orange: 0
      }
    end
    let(:cart_params) do
      {
        apple: -1,
        banana: -1,
        orange: -1
      }
    end

    it 'returns a valid cart' do
      expect(service.negative_params(cart_params)).to eq(expect_values)
    end
  end

  context 'when cart receive products' do
    it 'returns the cost of each product' do
      expect(service.build_products_amount).to eq(expect_values)
    end
  end

  context 'when cart receive invalid coupon name' do
    it 'returns that coupon is invalid' do
      expect(service.valid?('EH')).to be_falsey
    end
  end

  context 'when user get checkout' do
    it 'returns the cost of each product' do
      expect_values[:subtotal] = 190
      expect_values[:shipping] = 30
      expect_values[:total] = 220
      expect(service.build_checkout).to eq(expect_values)
    end
  end
end
