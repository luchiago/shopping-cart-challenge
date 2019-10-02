# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST coupon#add', type: :request do
  let(:expect_values) do
    {
      'id' => 1,
      'name' => 'A'
    }.with_indifferent_access
  end

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
      'Authorization' => 'teste2'
    }
  end

  context 'when consumer add a new coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: headers
    end

    it 'returns the added coupon' do
      expect(parsed['id']).to eq(expect_values['id'])
      expect(parsed['name']).to eq(expect_values['name'])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when consumer add the same coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: headers
    end

    it 'returns status code 400' do
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when consumer add an inexistent coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: headers
      post '/api/v1/coupon', params: { coupon: { name: 'EH' } }, headers: headers
    end

    it 'returns status code 400' do
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when consumer add a discount coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 3, banana: 1, orange: 4 } }, headers: { 'Authorization' => 'teste' }
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: { 'Authorization' => 'teste' }
      get '/api/v1/cart', headers: { 'Authorization' => 'teste' }
    end

    it 'returns the actual cart with updated values' do
      expect_cart[:subtotal] = 190
      expect(parsed).to eq(expect_cart)
    end
  end

  context 'when consumer add a free shiping coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { banana: 31 } }, headers: headers
      post '/api/v1/coupon', params: { coupon: { name: 'C' } }, headers: headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart with updated values' do
      expect_cart[:apple] = 0
      expect_cart[:banana] = 310
      expect_cart[:orange] = 0
      expect_cart[:subtotal] = 310
      expect_cart[:shipping] = 0
      expect_cart[:total] = 310
      expect(parsed).to eq(expect_cart)
    end
  end

  context 'when consumer add a fixed coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: headers
      post '/api/v1/coupon', params: { coupon: { name: 'FOO' } }, headers: headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart with updated values' do
      expect_cart[:apple] = 40
      expect_cart[:subtotal] = 170
      expect_cart[:total] = 100
      expect(parsed).to eq(expect_cart)
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
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: headers
      post '/api/v1/coupon', params: { coupon: { name: 'A' } }, headers: headers
      delete '/api/v1/coupon/1', headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when consumer delete inexistent coupon' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 2, banana: 1, orange: 4 } }, headers: headers
      delete '/api/v1/coupon/1', headers: headers
    end

    it 'returns status code 404' do
      expect(response).to have_http_status(:not_found)
    end
  end
end
