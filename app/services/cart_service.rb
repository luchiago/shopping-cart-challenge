class CartService

    def initialize(user)
        @user = user
    end

    def get_coupon(coupon)
        @user.coupons.find_by name: coupon
    end

    def get_products_amount
        products = {
          apple: @user[:apple] * 20,
          banana: @user[:banana] * 10,
          orange: @user[:orange] * 30
        }
        products
    end

    def subtotal_value
        subtotal = 0
        products = get_products_amount
        products.each { |key, value| subtotal += products[key] }
        subtotal
    end

    def shipping_value(subtotal)
        shipping = 0
        weight = @user[:apple] + @user[:banana] + @user[:orange]
        return shipping if subtotal > 400 or weight == 0
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
            puts '2'
            @user.coupons.all.each do |coupon|
                case coupon[:name]
                when 'A'
                    subtotal *= 0.7
                when 'FOO'
                    subtotal -= 100
                    subtotal < 0 ? subtotal = 0 : subtotal
                when 'C'
                    shipping = 0
                end
            end
        end
        total = subtotal + shipping
        return total.round(2), shipping
    end

    def get_cart_values
        subtotal = subtotal_value
        shipping = shipping_value(subtotal)
        total, shipping = get_coupons_benefits(subtotal, shipping)
        puts 'Get in here'
        values = { :subtotal => subtotal, :shipping=> shipping, :total => total }
    end

    def get_checkout
        products = get_products_amount
        values = get_cart_values
        data = Hash.new
        products.each { |product, amount| data[product] = amount }
        values.each { |type, amount| data[type] = amount }
        data
    end

    def calculate_discount(coupon)
        data = Hash.new
        data[:coupon] = coupon
        case coupon[:name]
        when 'A'
            data[:discount] = "$ #{-((subtotal_value * 0.3).round(2))}"
        when 'FOO'
            data[:discount] = "$ -100"
        when 'C'
            data[:discount] = "Free shipping"
        end
        data[:cart] = get_checkout
        data
    end

end