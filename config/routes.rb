Rails.application.routes.draw do
	
#	gets 'Advertisement#new'
	
#	get 'Advertisement#show'

#	GET 'Advertisement#index'

#	get 'Advertisement#create'

  resources :advertisements

  resources :posts

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
