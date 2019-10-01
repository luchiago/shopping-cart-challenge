Rails.application.routes.draw do
  namespace 'api' do
  	namespace 'v1' do
      patch 'cart/' => 'cart#update'
      get 'cart/' => 'cart#checkout'
      post 'coupon/' => 'coupon#add'
      delete 'coupon/:id' => 'coupon#delete'
    end
  end
end
