require "sinatra"
require "pry"

#Version 1.0

use Rack::Session::Cookie, {
  :expire_after => 2592000, # In seconds
  :secret => 'keep_it_secret_keep_it_safe'
}

before do
  @defeat = {"rock" => "scissors", "paper" => "rock", "scissors" => "paper"}
  @throws = @defeat.keys
end

result = []

get '/rps' do
  session[:player_points] ||= 0
  session[:computer_points] ||= 0
  erb :index, locals: { result: result }
end

post '/rps' do
  result = []
  player_throw = params[:choice]
  computer_throw = @throws.sample

    if session[:player_points] == 2
      result << "Player wins! Click reset for a new game =)"
    elsif session[:computer_points] == 2
      result << "Computer wins! Click reset for a new game =)"
    else
      if player_throw == computer_throw
        result << "You tied with the computer. No points!"
      elsif computer_throw == @defeat[player_throw]
        result << "Nicely done, #{player_throw} beats #{computer_throw}!"
        session[:player_points] += 1
      else
        result << "Ouch, #{computer_throw} beats #{player_throw}. Better luck next time!"
        session[:computer_points] += 1
      end
    end
    redirect '/rps'
end

post '/reset' do
  result = []
  session[:player_points] = 0
  session[:computer_points] = 0
  redirect '/rps'
end
