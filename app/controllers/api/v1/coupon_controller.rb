module Api
	module V1
    class CouponController < ApplicationController
      def add
        token = get_token
        user = find_cart(token)
        coupon = user.coupons.create(coupon_params)
        service = CartService.new(user)
        render json: service.calculate_discount(coupon)
      end

      def delete
        token = get_token
        user = find_cart(token)
        coupon = user.coupons.find(params[:id])
        coupon.destroy
        redirect_to '/api/v1/cart/'
      end

      private
      def get_token
        request.headers['Authorization']
      end

      def coupon_params
        params.require(:coupon).permit(:name)
      end

      def find_cart(token)
        user = User.find_by user_token: token
        user
      end

    end
  end
end