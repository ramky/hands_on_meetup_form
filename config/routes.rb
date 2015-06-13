Rails.application.routes.draw do
  resources :meetups
  root to: 'meetups#new'
end
