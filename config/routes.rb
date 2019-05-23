Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :lists
      delete 'lists/:id/unassign_member/:member_id', to: 'lists#unassign_member'
      post 'auth/login', to: 'authentication#authenticate'
      post 'signup', to: 'users#create'
      post 'lists/:id/assign_member/:member_id', to: 'lists#assign_member'
      get 'user', to: 'users#show'
    end
  end
end
