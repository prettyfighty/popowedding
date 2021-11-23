Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'comments#index'
  resources :users, path: '', param: :username, only: %i[edit update] do
    collection do
      get :sign_up, action: 'new'
      post :sign_up, action: 'create'
    end
    member do
      resources :comments, path: 'blessings', except: %i[edit update] do
        collection do
          get :lottery
          post :update_winner
        end
      end
    end
  end

  resources :sessions, path: 'user', only: [] do
    collection do
      get :sign_in, action: 'new'
      post :sign_in, action: 'create'
      delete :sign_out, action: 'destroy'
    end
  end
end
