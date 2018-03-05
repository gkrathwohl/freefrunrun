Rails.application.routes.draw do
  devise_for :users
  resources :results
  resources :athletes
  resources :races
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/races/:id/codes', to: 'races#codes', as: 'race_codes'
  get '/races/:id/timer', to: 'races#timer', as: 'race_timer'
  get '/qr/:race_hash/:place_hash', to: 'results#claim_result'
  post '/submit_results', to: 'results#submit_times'

  post '/submit_claim', to: 'results#submit_claim'

  get '/races/:id/results', to: 'races#results', as: 'race_results'
  get '/races/:id/course', to: 'races#course', as: 'race_course'

  get '/users/:id', to: 'users#show', as: 'user'


  root to: "home#index"
end
