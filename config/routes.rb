Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'base#status_check'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :courses, only: %i[index create]
      resource :sessions do
        post :auth_token
      end
    end
  end
end
