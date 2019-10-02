# frozen_string_literal: true

module Api
  module V1
    class CartController < ApplicationController
      def update
        user = find_cart(token)
        service = CartService.new(user)
        params = service.negative_params(cart_params)
        user.update(params)
        render json: service.build_checkout
      end

      def checkout
        user = find_cart(token)
        service = CartService.new(user)
        render json: service.build_checkout
      end

      private

        def token
          request.headers['Authorization']
        end

        def cart_params
          params.require(:cart).permit(:apple, :orange, :banana)
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
