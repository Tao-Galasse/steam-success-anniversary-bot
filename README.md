# Steam Success Anniversary Bot

A bot to retrieve my Steam's success and celebrate their completion anniversaries on Discord!

## Usage

### With Github Actions

#### Steam API setup

You can fork this repository and add your `STEAM_API_KEY` variable in the `settings/secrets/actions` section (be careful to never expose your `STEAM_API_KEY` publicly).  
You can get one [here](https://steamcommunity.com/dev/apikey).
You will also need to set your `STEAM_USER_ID` ; you can get it on your profile, in the URL.

#### Timezone setup

If you want to use a custom timezone, you can define your `TZ` variable in the `settings/variables/actions` section. By default, it will be Europe/Paris, as defined in the source code.

#### Discord setup

To send custom messages to celebrate your anniversaries on Discord, you will need to create a bot.

Visit https://discord.com/developers/applications and create a new application.  
Go to the `Bot` section and add your new bot to your Discord server!  
Then, you will need to allow it to `Send Messages` and get your token.  
Add it as a new variable `DISCORD_TOKEN` to your repository in the `settings/secrets/actions` section (this token should never be exposed publicly too).

Finally, add the variable `DISCORD_CHANNEL_ID` in the same section to choose where you want to send your messages.  
To get the ID of a Discord channel, you need to enable the `Developer Mode` in `User Settings > Advanced`.

You can also update the message sent to your Discord channel in the `steam_success_anniversary_bot.rb` file (it will require to commit the change).

### Locally

- Install Ruby 3.4.4.
- Add a `.env` file following the format given in `.env.example`.
- Install dependencies with `bundle install` thanks to [bundler](https://bundler.io/). 
- Run `ruby steam_success_anniversary_bot.rb`!
