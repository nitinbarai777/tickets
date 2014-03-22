Tickets::Application.routes.draw do
  
  resources :posts

  namespace :admin do
    resources :users, :tickets, :settings, :footer_pages, :contacts, :languages, :email_templates, :companies
    match 'dashboard' => 'dashboard#index', :as => :dashboard, via: [:get, :post]
  end

  resources :user_sessions

  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'login' => 'user_sessions#new', :as => :login
  get 'admin' => 'user_sessions#new', :as => :admin
  match 'signup(/:registration_key)' => 'user_sessions#signup', :as => :signup, via: [:get, :post, :patch]

  match '/forgot_password' => 'fronts#forgot_password', :as => :forgot_password, via: [:get, :post]
  match '/change_password' => 'fronts#change_password', :as => :change_password, via: [:get, :post, :patch]
  get 'dashboard' => 'fronts#dashboard', :as => :dashboard
  match 'activate/:activation_key' => 'fronts#user_activation', :as => :activation_link, via: [:get]
  match '/profile' => 'fronts#profile', :as => :profile, via: [:get, :post, :patch]
  get '/show_search_box/:toggle/:model/:pm' => 'fronts#show_search_box', :as => :show_search_box
  match 'contact_us' => 'fronts#contact_us', :as => :contact_us, via: [:get, :post, :patch]
  get '/other/:page_id' => 'fronts#other', :as => :other
  get '/:sub_domain' => 'fronts#company_front', :as => :company_front


  namespace :support do
    resources :tickets
  end
  
  post '/support/reply/create' => 'support/tickets#reply_create', :as => 'reply_create'
  
  post '/support/update/ticket' => 'support/tickets#update_ticket', :as => 'update_ticket'
  
  get '/SupportTicket/:id/:model' => 'fronts#download', :as => :download
  
  
  # staff routes
  get '/staff/tickets' => 'staff#tickets', :as => :staff_tickets
  get '/ticket/reply/:id' => 'staff#ticket_reply', :as => :ticket_reply
  post '/ticket/reply/create' => 'staff#ticket_reply_create', :as => :ticket_reply_create
  # You can have the root of your site routed with "root"
  
  match '/join/us' => 'fronts#join_us', :as => 'join_us', via: [:get, :post, :patch]
  
  root 'fronts#dashboard'

end
