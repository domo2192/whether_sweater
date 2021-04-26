Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get 'forecast', to: 'forecast#show'
      get 'backgrounds', to: 'background#show'
      post 'users', to: 'user#create'
      post 'sessions', to: 'session#create'
      get 'salaries', to: 'salary#show'
    end

  end
end
