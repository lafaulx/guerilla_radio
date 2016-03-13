# GuerillaRadio

## What's it for and how do I use it?

This is a concept broadcasts application for your website that uses Slack as backend to send messages and manage broadcast channels. Broadcasting process should look like that:

  1. create `guerilla_radio` bot for your app;
  2. run this app with `guerilla_radio` bot API auth token in config;
  3. invite a bot in a channel – from this moment all messages sent to this channel will be saved by this app;
  4. embed iframe `src='this_app_server_addr/?broadcast=slack_channel_name' and share the broadcast to your website users.


## How to run the server

  1. clone this repo;
  2. setup VM with dev env if you need – `vagrant up && vagrant ssh` – source code will be in `~/guerilla_radio`;
  3. install dependencies with `mix deps.get`;
  4. create and migrate db with `mix ecto.create && mix ecto.migrate`;
  5. rename `config/dev.secret.example.exs to config/dev.secret.exs` and add Slack token there (do the same with prod config);
  6. Start Phoenix endpoint with `mix phoenix.server`
  7. Visit [`localhost:4000/?broadcast=broadcast_channel_name`](http://localhost:4000/?broadcast=broadcast_channel_name) and check the broadcast from your Slack channel.

## And?

This is only a concept (never tested in serious environment) so don't blame me. Anyway you can try and maybe contribute something into this stuff. Any comments are accepted.