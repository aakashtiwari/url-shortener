Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'url#index'
  
  #create routes for accessing url
  resources :url, only: [:create, :show]

  namespace :api do
    resources :urls, only: [:create, :show, :index, :destroy] do
    	post 'download_urls', on: :collection 
    end
  end
end
