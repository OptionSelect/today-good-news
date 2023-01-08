Rails.application.routes.draw do
  resources :posts
  get '/posts/get_posts', to: 'posts#get_posts'
  root 'posts#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
