# Spomodorify

Spomodorify starts your Pomodoro by starting your Spotify player. After the Pomodoro is finished, Spomodorify gradually lowers the Spotify volume to 0, pauses the player and sets the volume to 100%.
No distracting noises or visual notifications*, just your favourite music fading away... ahh.

This idea was inspired by a similar concept from [Noisli](https://www.noisli.com/).

## Installation

First, clone the repo. Or just copy the code and make a file on your computer. Or whatever.

To make Spomodorify work, you need tokens. So many tokens. Follow the [Authorization Guide](https://developer.spotify.com/documentation/general/guides/authorization-guide/). In short:

- [Register your app](https://developer.spotify.com/documentation/general/guides/app-settings/#register-your-app) to get the **client id** and **client secret**.
- Follow the [Authorization Code flow](https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow) to get the **refresh token**. You can use [ngrok](https://ngrok.com/) or [Request Bin](https://requestbin.fullcontact.com/) or sth similar to easily capture the redirect.

After you acquire the tokens, create `SPOTIFY_REFRESH_TOKEN`, `SPOTIFY_CLIENT_ID` and `SPOTIFY_CLIENT_SECRET` env variables. Like this: `export SPOTIFY_CLIENT_ID=xxxxxx` in your `~/.bashrc` or `~/.zhsrc` or sth like that.

I admit, it's a cumbersome process. I made this app for myself so it doesn't make sense to implement an installation flow.
If you really like the idea behind Spomodorify, let me know. If enough people like it I will make the installation so easy that an unborn baby will be able to do it.

## Usage

Open your Spotify, go to the Spomodorify folder and run:

```ruby app.rb```

By default, it starts 25 minutes long Pomodoro. If you want to have a custom time you can provide it as a parameter:

```ruby app.rb 15```

*If you want to get a visual notification, add `notify` as a second argument:

```ruby app.rb 25 notify```
