class CartService
  def initialize(user)
    @user = user
  end

  def get_coupon(coupon)
    @user.coupons.find_by name: coupon
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

    if weight <= 10
      shipping = 30
      return shipping
    end
    shipping = 7
    shipping *= ((weight - 10) / 5)
    shipping
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
    total, shipping = get_coupons_benefits(subtotal, shipping)
    values = { subtotal: subtotal, shipping: shipping, total: total }
  end

  def build_checkout
    products = build_products_amount
    values = build_cart_values
    data = {}
    products.each { |product, amount| data[product] = amount }
    values.each { |type, amount| data[type] = amount }
    data
  end

  def calculate_discount(coupon)
    data = {}
    data[:coupon] = coupon
    case coupon[:name]
    when 'A'
      data[:discount] = "$ #{-(subtotal_value * 0.3).round(2)}"
    when 'FOO'
      data[:discount] = '$ -100'
    when 'C'
      data[:discount] = 'Free shipping'
    end
    data[:cart] = build_checkout
    data
  end
end
