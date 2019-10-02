# frozen_string_literal: true

module Api
  module V1
    class CouponController < ApplicationController
      def add
        user = find_cart(token)
        service = CartService.new(user)
        coupon = service.valid?(coupon_params[:name])
        if coupon
          coupon = user.coupons.create(coupon_params)
          render json: coupon
        else
          render json: { message: 'invalid' }, status: 400
        end
      end

      def delete
        user = find_cart(token)
        begin
          coupon = user.coupons.find(params[:id])
          coupon.destroy
          render json: coupon
        rescue ActiveRecord::RecordNotFound
          render json: { message: 'not found' }, status: 404
        end
      end

      private

        def token
          request.headers['Authorization']
        end

        def coupon_params
          params.require(:coupon).permit(:name)
        end

        def find_cart(token)
          user = User.find_by user_token: token
          user ||= create_cart(token)
          user
        end

        def create_cart(token)
          user_params = { user_token: token, apple: 0, banana: 0, orange: 0 }
          User.new(user_params).tap(&:save)
        end
    end
  end
end
