# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'discordrb'
require 'steam-api'
require 'tzinfo'

def fetch_game_ids
  Steam::Player.owned_games(@user_id)['games'].map { _1['appid'] }
end

def completed_games(game_ids)
  game_ids.map { |game_id| fetch_game_achievements(game_id) }.compact # games with achievements
          .select { |game| game['achievements'].all? { _1['achieved'] == 1 } } # games with 100% completion
          .map { |game| { name: game['gameName'], date: completion_date(game) } } # format the result
end

def fetch_game_achievements(game_id)
  Steam::UserStats.player_achievements(game_id, @user_id)
rescue Steam::SteamError => _e # some games do not support achievements: we ignore them
  nil
end

def completion_date(game)
  epoch_time = game['achievements'].map { _1['unlocktime'] }.max
  Time.at(epoch_time, in: @tz)
end

# Select every game where completion was achieved the same day and month than today, at least 1 year ago
def my_anniversaries(completed_games)
  completed_games.select do |game|
    game[:date].strftime('%d/%m') == Date.today.strftime('%d/%m') && game[:date].year != Date.today.year
  end
end

def anniversary_message(game, user_name)
  age = Date.today.year - game[:date].year
  years = age == 1 ? 'an' : 'ans'

  "Aujourd'hui, nous célébrons la complétion de #{game[:name]} par #{user_name}, il y a #{age} #{years} !"
end

@user_id = ENV.fetch('STEAM_USER_ID')
@tz = TZInfo::Timezone.get(ENV.fetch('TZ', 'Europe/Paris'))

completed_games = completed_games(fetch_game_ids)
anniversaries = my_anniversaries(completed_games)
return if anniversaries.empty?

# If we have at least one anniversary to celebrate, we want to say it on Discord!
discord_bot = Discordrb::Bot.new(token: ENV['DISCORD_TOKEN'])
user_name = Steam::User.summary(@user_id)['personaname']

anniversaries.each do |game|
  message = anniversary_message(game, user_name)
  discord_bot.send_message(ENV['DISCORD_CHANNEL_ID'], message)
end
