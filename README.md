# HOW TO RUN?

* `git clone https://gitlab.com/vivnau/blackjack.git`
* `cd ror_vivek/blackjack`
* `bundle install` to install all the package dependencies
* `rails db:migrate` to create database tables
* `rails s` to start the server
* `localhost:3000` is the base_url for the api server

# API Documentation

* users : POST API /api/v1/create_user
  parameters required : {
    "name" : Name of the user,
    "coins" : Number of coins
  }

  will return the id of the new user created ( to be used later to create new game).

* create_game : POST API /api/v1/create_game
  parameters required : {
    "players" : [array of ids of users playing the game],
    "decks" : total number of decks to be added to the card store
  }

  will return the id of the new game create

* deal : POST API /api/v1/deal
  parameters required : {
    "id" : game id,
    "coins" : [array of coins bet by players in the order of the above players array]
  }

  will return the round_info, dealer_cards and cards for each player in the hand( hand_id ) and hand_status, which is either ROUND_UNDERWAY, or INSURANCE

* insurance : POST API /api/v1/insurance
  parameters required : {
    "round_id" : round id,
    "insurance" : [ array of coins for different hands { "hand_id", "insurance" : number coins for the insurance wager}]
  }

  insurance amount can be maximum up to half of the original bet

* hit : GET API /api/v1/hit/:hand_id

  will hit with another card only if the hand_status is set to ACTIVE, which goes in order to the next player if the current hand goes bust, at any given time only one hand is ACTIVE, once all hands are dealt the final results are processed and stored in the db

* stand : GET API /api/v1/stand/:hand_id

  will stand and move to another hand only if the hand_status is set to ACTIVE, which goes in order to the next player, once all hands are dealt the final results are processed and stored in the db

* game_status : GET API api/v1/status/:game_id

  provides a full snapshot of the game along with cards in different rounds for different hands played by various players, and the various bets associated with it, the payoffs and insurances

* winner : GET API api/v1/winner/:game_id

  provides a full list of winners for different rounds throughout the game and the payoffs

* finish_game : GET API api/v1/finish_game/:game_id

  sets the game status and status of any unfinished rounds to FINISHED, status of a finished game can be accessed later using game_status api but the game cannot be played.
