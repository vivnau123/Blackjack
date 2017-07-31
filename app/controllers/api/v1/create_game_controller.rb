module Api
  module V1
    class CreateGameController < ApplicationController
      def index
        games = Game.order('created_at DESC');
        render json: {status: 'SUCCESS', message: 'Loaded games', data:games}, status: :ok
      end

      def create
        game = Game.new(new_game_params)
        cards = Array.new(new_game_params[:decks].to_i*52) {|i| i+1 }
        game.cards = cards
        if game.save
          i = 0
          new_game_params[:players].each do |player_id|
            if User.exists?(id: player_id)
              userGame = UserGame.new(user_id: player_id, game_id: game.id)
              userGame.save
              i = i + 1
            else
              game.status = 'INVALID'
              game.save
              render json: {status: 'ERROR', message: 'Please enter valid user_ids'}, status: :unprocessable_entry
              break
            end
          end
          if i == new_game_params[:players].length
            game.status = 'ACTIVE'
            render json: {message: 'Game created', data:game}, status: :ok
          end
        else
          render json: {status: 'ERROR', message: 'Game not created', error: game.errors}, status: :unprocessable_entry
        end
      end

      private

      def new_game_params
        params.permit(:decks, :players => []);
      end
    end
  end
end
