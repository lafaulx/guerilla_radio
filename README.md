# GuerillaRadio

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Edit `lib/guerilla_radio.ex` – add Slack API token
  4. Start Phoenix endpoint with `mix phoenix.server`
  5. Visit [`localhost:4000/?broadcast=general`](http://localhost:4000/?broadcast=general) and check the broadcast from your Slack channel.