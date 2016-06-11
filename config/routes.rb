Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create, :destroy, :avatar_url]

  get 'about' => 'welcome#about'

  root 'welcome#index'
end

# look up marquee sponsored posts.
