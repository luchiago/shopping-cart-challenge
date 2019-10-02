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
      patch '/api/v1/cart', params: { cart: { apple: 3, banana: 1, orange: 4 } }, headers: :headers
    end

    it 'returns the actual cart' do
      expect(:parsed).to equal(:expect_values)
    end

    it { is_expected.to respond_with_content_type(:json) }

    it { is_expected.to respond_with 200 }
  end

  context 'when user update cart with some products' do
    :expect_values[:apple] = 0
    :expect_values[:subtotal] = 130
    :expect_values[:total] = 160

    before do
      patch '/api/v1/cart', params: { cart: { banana: 1, orange: 4 } }, headers: :headers
    end

    it 'returns the actual cart' do
      expect(:parsed).to equal(:expect_values)
    end

    it { is_expected.to respond_with 200 }
  end

  context 'when user update cart with negative amount' do
    :expect_values[:apple] = 0
    :expect_values[:subtotal] = 130
    :expect_values[:total] = 160

    before do
      patch '/api/v1/cart', params: { cart: { apple: -1, banana: 1, orange: 4 } }, headers: :headers
    end

    it 'returns the actual cart' do
      expect(:parsed).to equal(:expect_values)
    end

    it { is_expected.to respond_with 200 }
  end
end

RSpec.describe 'GET cart#checkout', type: :request do
  let(:parsed) { JSON.parse(response.body) }

  context 'when user wants to get checkout' do
    let(:expect_values) do
      {
        'apple' => 120,
        'banana' => 60,
        'orange' => 0,
        'subtotal' => 190,
        'shipping' => 30,
        'total' => 220
      }.with_indifferent_access
    end

    before do
      patch '/api/v1/cart', params: { cart: { apple: 6, banana: 6, orange: 0 } }, headers: :headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(:parsed).to equal(:expect_values)
    end

    it { is_expected.to respond_with_content_type(:json) }

    it { is_expected.to respond_with 200 }
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
      patch '/api/v1/cart', params: { cart: { apple: 21 } }, headers: :headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(:parsed).to equal(:expect_values)
    end
  end

  context 'when weight is bellow or equal 10kg' do
    let(:expect_values) do
      {
        'apple' => 80,
        'banana' => 60,
        'orange' => 0,
        'subtotal' => 140,
        'shipping' => 30,
        'total' => 170
      }.with_indifferent_access
    end

    before do
      patch '/api/v1/cart', params: { cart: { apple: 6, banana: 4 } }, headers: :headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(:parsed).to equal(:expect_values)
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
      patch '/api/v1/cart', params: { cart: { apple: 10, banana: 5 } }, headers: :headers
      get '/api/v1/cart', headers: headers
    end

    it 'returns the actual cart' do
      expect(:parsed).to equal(:expect_values)
    end
  end
end
