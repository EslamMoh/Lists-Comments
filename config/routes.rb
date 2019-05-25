Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :lists
      delete 'lists/:id/unassign_member/:member_id', to: 'lists#unassign_member'
      delete 'cards/:id', to: 'cards#destroy'
      put 'cards/:id', to: 'cards#update'
      post 'auth/login', to: 'authentication#authenticate'
      post 'signup', to: 'users#create'
      post 'lists/:id/assign_member/:member_id', to: 'lists#assign_member'
      post 'cards/:list_id', to: 'cards#create'
      get 'cards/:list_id/:id', to: 'cards#show'
      get 'cards/:list_id', to: 'cards#index'
      get 'user', to: 'users#show'
    end
  end
end
