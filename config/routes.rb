Gmaps::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'events#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get '/signup',              to: 'users#new'
  get '/signin',              to: 'sessions#new'
  get '/signout',             to: 'sessions#destroy', via: :delete
  get '/find-events',         to: 'events#find', as: :find_events
  get '/find-users',          to: 'users#find', as: :find_users
  get '/find-tags',           to: 'categories#find', as: :find_tags
  get '/create-tags',         to: 'categories#create', as: :create_tags
  get '/invite-users',        to: 'users#invite'
  get '/notifications',       to: 'activities#index'
  get '/settings',            to: 'users#settings'
  get '/history',             to: 'users#history'
  get '/pals',                to: 'events#pals'


  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :events do
    resources :images, shallow: true do
      member { post :vote }
    end
  end
  resources :users do
    member do
      get :sharees, :sharers
    end
  end
  resources :sessions,          only: [:new, :create, :destroy]
  resources :relationships,     only: [:create, :destroy]
  resources :attendances,       only: [:create, :destroy]
  resources :invites,           only: [:create, :destroy]
  resources :comments,          only: [:create, :destroy, :update]
  resources :categories,        only: [:index]

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
