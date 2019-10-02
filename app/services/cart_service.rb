# frozen_string_literal: true

class CartService
  def initialize(user)
    @user = user
  end

  def duplicated?(coupon)
    @user.coupons.find_by name: coupon
  end

  def valid?(name)
    coupons = %w[A FOO C]
    (coupons.include?name) && !(duplicated? name)
  end

  def negative_params(cart_params)
    cart_params.each do |key, _value|
      cart_params[key] = 0 if cart_params[key].to_i.negative?
    end
    cart_params
  end

  def build_products_amount
    products = {
      apple: @user[:apple] * 20,
      banana: @user[:banana] * 10,
      orange: @user[:orange] * 30
    }
    products
  end

  def subtotal_value
    subtotal = 0
    products = build_products_amount
    products.each { |key, _value| subtotal += products[key] }
    subtotal
  end

  def shipping_value(subtotal)
    shipping = 0
    weight = @user[:apple] + @user[:banana] + @user[:orange]
    return shipping if (subtotal > 400) || weight.zero?

    shipping = 30
    return shipping if weight <= 10

    multiplier = 7
    multiplier *= ((weight - 10) / 5)
    shipping + multiplier
  end

  def get_coupons_benefits(subtotal, shipping)
    if @user.coupons.all.size
      @user.coupons.all.each do |coupon|
        case coupon[:name]
        when 'A'
          subtotal *= 0.7
        when 'FOO'
          subtotal -= 100
          subtotal = 0 if subtotal.negative?
        when 'C'
          shipping = 0
        end
      end
    end
    total = subtotal + shipping
    [total.round(2), shipping]
  end

  def build_cart_values
    subtotal = subtotal_value
    shipping = shipping_value(subtotal)
    updated = get_coupons_benefits(subtotal, shipping)
    shipping = updated[1]
    total = updated[0]
    { subtotal: subtotal, shipping: shipping, total: total }
  end

  def build_checkout
    products = build_products_amount
    values = build_cart_values
    data = {}
    products.each { |product, amount| data[product] = amount }
    values.each { |type, amount| data[type] = amount }
    data
  end
end
