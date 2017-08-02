Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users
      resources :create_game
      resources :deal
      resources :insurance
      resources :game_status
      resources :finish_game
    end
  end
end
