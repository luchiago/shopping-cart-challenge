Rails.application.routes.draw do
  patch 'cart/' => 'cart#update'
  get 'cart/' => 'cart#checkout'
  post 'coupon/' => 'coupons#add'
  delete 'coupon/:id' => 'coupons#delete'
end
