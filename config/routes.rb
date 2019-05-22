Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'auth/login', to: 'authentication#authenticate'
      post 'signup', to: 'users#create'
      get 'user', to: 'users#show'
    end
  end
end
