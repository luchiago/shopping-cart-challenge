Rails.application.routes.draw do
  namespace 'api' do
  	namespace 'v1' do
      patch 'cart/' => 'cart#update'
      get 'cart/' => 'cart#checkout'
      post 'coupon/' => 'coupons#add'
      delete 'coupon/:id' => 'coupons#delete'
    end
  end
end
