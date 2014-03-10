Tickets::Application.routes.draw do
  resources :posts

  #faye_server '/faye', timeout: 25
  #get '/chat', to: RealtimeChatController

  namespace :admin do
    resources :users, :tickets, :settings, :footer_pages, :contacts, :languages, :email_templates
  end

  resources :user_sessions

  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'login' => 'user_sessions#new', :as => :login
  match 'signup(/:registration_key)' => 'user_sessions#signup', :as => :signup, via: [:get, :post, :patch]

  match '/forgot_password' => 'fronts#forgot_password', :as => :forgot_password, via: [:get, :post]
  match '/change_password' => 'fronts#change_password', :as => :change_password, via: [:get, :post, :patch]
  get 'dashboard' => 'fronts#dashboard', :as => :dashboard
  match 'activate/:activation_key' => 'fronts#user_activation', :as => :activation_link, via: [:get]
  match '/profile' => 'fronts#profile', :as => :profile, via: [:get, :post, :patch]
  get '/show_search_box/:toggle/:model/:pm' => 'fronts#show_search_box', :as => :show_search_box
  match 'contact_us' => 'fronts#contact_us', :as => :contact_us, via: [:get, :post, :patch]
  get '/other/:page_id' => 'fronts#other', :as => :other

  resources :tickets
  
  post '/reply/create' => 'tickets#reply_create', :as => 'reply_create'
  
  get '/SupportTicket/:id/:model' => 'fronts#download', :as => :download
  
  
  # staff routes
  get '/staff/tickets' => 'staff#tickets', :as => :staff_tickets
  get '/ticket/reply/:id' => 'staff#ticket_reply', :as => :ticket_reply
  post '/ticket/reply/create' => 'staff#ticket_reply_create', :as => :ticket_reply_create
  # You can have the root of your site routed with "root"
  root 'fronts#dashboard'

end
