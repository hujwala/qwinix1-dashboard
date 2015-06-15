Rails.application.routes.draw do
  mount Dashing::Engine, at: Dashing.config.engine_path
  root :to => 'admin/sessions#index'
  get 'users/unique_email' => 'admin/users#unique_email'
  # get "log_in" => "users#new", :as => "log_in"

  # Sign In URLs for users
  # get     '/sign_in',         to: "public/user_sessions#sign_in",         as:  :sign_in
  # post    '/create_session',  to: "public/user_sessions#create_session",  as:  :create_session
  # Logout Url
  # delete  '/sign_out' ,       to: "public/user_sessions#sign_out",        as:  :sign_out

  namespace :admin do
    resources :users
    resources :updates do
      mount Dashing::Engine, at: Dashing.config.engine_path     
    end
    resources :sessions
    get :admin_role
    resources :dashboards do
      mount Dashing::Engine, at: Dashing.config.engine_path
      resources :dashboard_widgets
    end
  end
  # post "pop_up" => "admin/dashboards#pop_up"
  # ------------
  # User pages
  # ------------

  # namespace :users do
  #   get   '/dashboard',         to: "dashboard#index",  as:   :dashboard
  #   get   '/profile',           to: "profile#index",    as:   :profile
  #   get   '/edit',              to: "profile#edit",     as:   :edit
  #   put   '/update',            to: "profile#update",   as:   :update

  #   resources :images do
  #     member do
  #       put :crop
  #     end
  #   end
  # end

end



