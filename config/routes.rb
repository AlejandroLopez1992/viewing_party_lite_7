# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  get '/register', to: 'users#new'
  resources :users, only: %i[new show create] do
    resources :discover, only: %i[index]
    resources :movies, only: %i[show index] do
     resources :viewing_parties, only: %i[new show create]
    end
  end
end
