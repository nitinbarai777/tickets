Tickets::Application.routes.draw do
  
  resources :posts

  namespace :admin do
    resources :users, :tickets, :settings, :footer_pages, :contacts, :languages, :email_templates 
    match 'dashboard' => 'dashboard#index', :as => :dashboard, via: [:get, :post]

    resources :companies do
      collection do
        get :users
      end
    end
  end
  
  resources :users, :path => "companies/:sub_domain/users/"
  resources :company_tickets, :path => "companies/:sub_domain/company_tickets/" 

  resources :user_sessions

  get 'logout' => 'user_sessions#destroy', :as => :logout
  get '/companies/:sub_domain/login' => 'user_sessions#new', :as => :login
  get 'admin' => 'user_sessions#new', :as => :admin
  match '/companies/:sub_domain/signup(/:registration_key)' => 'user_sessions#signup', :as => :signup, via: [:get, :post, :patch]

  match '/companies/:sub_domain/forgot_password' => 'fronts#forgot_password', :as => :forgot_password, via: [:get, :post]
  match '/forgot_password' => 'fronts#forgot_password', :as => :admin_forgot_password, via: [:get, :post]
  
  
  match '/companies/:sub_domain/change_password' => 'fronts#change_password', :as => :change_password, via: [:get, :post, :patch]
  match '/change_password' => 'fronts#change_password', :as => :admin_change_password, via: [:get, :post, :patch]
  
  
  get 'dashboard' => 'fronts#dashboard', :as => :dashboard
  match 'activate/:activation_key' => 'fronts#user_activation', :as => :activation_link, via: [:get]
  
  match '/companies/:sub_domain/profile' => 'fronts#profile', :as => :profile, via: [:get, :post, :patch]
  match '/profile' => 'fronts#profile', :as => :admin_profile, via: [:get, :post, :patch]
  
  match '/companies/:sub_domain/company/profile' => 'fronts#company_profile', :as => :company_profile, via: [:get, :post, :patch]
  get '/show_search_box/:toggle/:model/:pm' => 'fronts#show_search_box', :as => :show_search_box
  match 'contact_us' => 'fronts#contact_us', :as => :contact_us, via: [:get, :post, :patch]
  get '/other/:page_id' => 'fronts#other', :as => :other
  get '/companies/:sub_domain' => 'fronts#company_front', :as => :company_front


  #namespace :support do
    resources :tickets, :path => "companies/:sub_domain/tickets/"
  #end
  
  post '/companies/:sub_domain/reply/create' => 'tickets#reply_create', :as => 'reply_create'
  
  post '/companies/:sub_domain/update/ticket' => 'tickets#update_ticket', :as => 'update_ticket'
  
  get '/companies/:sub_domain/SupportTicket/:id/:model' => 'fronts#download', :as => :download
  
  
  # staff routes
  get '/companies/:sub_domain/staff/tickets' => 'staff#tickets', :as => :staff_tickets
  get '/companies/:sub_domain/ticket/reply/:id' => 'staff#ticket_reply', :as => :ticket_reply
  post '/companies/:sub_domain/ticket/reply/create' => 'staff#ticket_reply_create', :as => :ticket_reply_create
  # You can have the root of your site routed with "root"
  
  match '/join/us' => 'fronts#join_us', :as => 'join_us', via: [:get, :post, :patch]
  
  root 'fronts#dashboard'

end
