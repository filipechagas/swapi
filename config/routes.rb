Rails.application.routes.draw do
  root "home#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :searches, only: [ :create ]
      resources :statistics, only: [ :index ] do
        collection do
          get :popular_searches_by_type
        end
      end
    end
  end
end
