Rails.application.routes.draw do
  resources :products, only: [:index, :show, :create]
end
