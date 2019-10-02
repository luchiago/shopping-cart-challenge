# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH cart#update', type: :request do
  let(:expect_values) do
    {
      'apple' => 60,
      'banana' => 10,
      'orange' => 120,
      'subtotal' => 190,
      'shipping' => 30,
      'total' => 220
    }.with_indifferent_access
  end

  let(:parsed) { JSON.parse(response.body) }

  let(:headers) do
    {
      'Authorization' => 'teste1'
    }
  end

  context 'when user update cart with all products' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: 3, banana: 1, orange: 4 } }, headers: headers
    end

    it 'returns the actual cart' do
      expect(parsed).to eq(expect_values)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when user update cart with some products' do
    before do
      patch '/api/v1/cart', params: { cart: { orange: 5 } }, headers: headers
    end

    it 'returns the actual cart' do
      expect_values[:apple] = 0
      expect_values[:banana] = 0
      expect_values[:orange] = 150
      expect_values[:subtotal] = 150
      expect_values[:total] = 180
      expect(parsed).to eq(expect_values)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when user update cart with negative amount' do
    before do
      patch '/api/v1/cart', params: { cart: { apple: -1, banana: 1, orange: 4 } }, headers: headers
    end

    it 'returns the actual cart' do
      expect_values[:apple] = 0
      expect_values[:subtotal] = 130
      expect_values[:total] = 160
      expect(parsed).to eq(expect_values)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end
end

RSpec.describe 'GET cart#checkout', type: :request do
  let(:parsed) { JSON.parse(response.body) }

  let(:headers) do
    {
      'Authorization' => 'teste1'
    }
  end

  context 'when user wants to get checkout' do
    let(:expect_values) do
      {
        'apple' => 120,
        'banana' => 60,
        'orange' => 0,
        'subtotal' => 180,
        'shipping' => 30,
        'total' => 210
      }.with_indifferent_access
    end

    before do
      patch '/api/v1/cart', params: { cart: { apple: 6, banana: 6, orange: 0 } }, headers: headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(parsed).to eq(expect_values)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when shipping is free' do
    let(:expect_values) do
      {
        'apple' => 420,
        'banana' => 0,
        'orange' => 0,
        'subtotal' => 420,
        'shipping' => 0,
        'total' => 420
      }.with_indifferent_access
    end

    before do
      patch '/api/v1/cart', params: { cart: { apple: 21, banana: 0, orange: 0 } }, headers: headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(parsed).to eq(expect_values)
    end
  end

  context 'when weight is bellow or equal 10kg' do
    let(:expect_values) do
      {
        'apple' => 120,
        'banana' => 40,
        'orange' => 0,
        'subtotal' => 160,
        'shipping' => 30,
        'total' => 190
      }.with_indifferent_access
    end

    before do
      patch '/api/v1/cart', params: { cart: { apple: 6, banana: 4, orange: 0 } }, headers: headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(parsed).to eq(expect_values)
    end
  end

  context 'when weight is above 10kg' do
    let(:expect_values) do
      {
        'apple' => 200,
        'banana' => 50,
        'orange' => 0,
        'subtotal' => 250,
        'shipping' => 37,
        'total' => 287
      }.with_indifferent_access
    end

    before do
      patch '/api/v1/cart', params: { cart: { apple: 10, banana: 5, orange: 0 } }, headers: headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(parsed).to eq(expect_values)
    end
  end

  context 'when user have nothing in cart' do
    let(:expect_values) do
      {
        'apple' => 0,
        'banana' => 0,
        'orange' => 0,
        'subtotal' => 0,
        'shipping' => 0,
        'total' => 0
      }.with_indifferent_access
    end

    before do
      get '/api/v1/cart', headers: { 'Authorization' => 'teste2' }
    end

    it 'returns the actual cart' do
      expect(parsed).to eq(expect_values)
    end
  end
end
