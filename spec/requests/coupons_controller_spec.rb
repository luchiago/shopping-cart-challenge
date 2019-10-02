require 'rails_helper'

RSpec.describe 'POST coupon#add', type: :request do
  let(:parsed) { JSON.parse(response.body) }

  let(:expect_values) do
    {
      'id' => 1,
      'name' => 'A'
    }
  end

  let(:expect_cart) do
    {
      'apple' => 60,
      'banana' => 10,
      'orange' => 120,
      'subtotal' => 190,
      'shipping' => 30,
      'total' => 163
    }.with_indifferent_access
  end

  let(:headers) do
    {
      'Authorization' => 'teste1'
    }
  end

  context 'when consumer add a new coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: :headers
    end

    it 'returns the added coupon' do
      expect(:parsed[:id]).to eq(:expect_values[:id])
      expect(:parsed[:name]).to eq(:expect_values[:name])
    end

    it { is_expected.to respond_with_content_type(:json) }

    it { is_expected.to respond_with 200 }
  end

  context 'when consumer add the same coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: :headers
    end

    it { is_expected.to respond_with 400 }
  end

  context 'when consumer add an inexistent coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'EH' } }, headers: :headers
    end

    it { is_expected.to respond_with 400 }
  end

  context 'when consumer add a discount coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: :headers
      get 'api/v1/coupon', headers: :headers
    end

    it 'returns the actual cart with updated values' do
      expect(:parsed).to equal(:expect_cart)
    end
  end

  context 'when consumer add a free shiping coupon' do
    before do
      :expect_cart[:apple] = 0
      :expect_cart[:banana] = 310
      :expect_cart[:orange] = 0
      :expect_cart[:subtotal] = 310
      :expect_cart[:shipping] = 0
      :expect_cart[:total] = 30
      patch '/api/v1/cart', params: { cart: { banana: 31 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'C' } }, headers: :headers
      get 'api/v1/coupon', headers: :headers
    end

    it 'returns the actual cart with updated values' do
      expect(:parsed).to equal(:expect_cart)
    end
  end

  context 'when consumer add a fixed coupon' do
    before do
      :expect_cart[:total] = 90
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'FOO' } }, headers: :headers
      get 'api/v1/coupon', headers: :headers
    end

    it 'returns the actual cart with updated values' do
      expect(:parsed).to equal(:expect_cart)
    end
  end
end

describe 'DELETE coupon#delete', type: :request do
  let(:parsed) { JSON.parse(response.body) }

  let(:expect_cart) do
    {
      'apple' => 60,
      'banana' => 10,
      'orange' => 120,
      'subtotal' => 190,
      'shipping' => 30,
      'total' => 163
    }.with_indifferent_access
  end

  let(:headers) do
    {
      'Authorization' => 'teste1'
    }
  end

  context 'when consumer delete a coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: :headers
      delete '/api/v1/coupon/1', headers: :headers
    end

    it { is_expected.to respond_with 200 }
  end

  context 'when consumer delete inexistent coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: :headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: :headers
      delete '/api/v1/coupon/2', headers: :headers
    end

    it { is_expected.to respond_with 404 }
  end
end
