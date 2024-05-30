Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  get "spread/:market_id", to: "application#spread"
  get "spreads", to: "application#all_spreads"
  get "markets", to: "application#markets"
  post "spread_alert", to: "application#save_spread_alert"
  get "spread_alert/:market_id", to: "application#poll_spread_alert"
  root "application#index"
end