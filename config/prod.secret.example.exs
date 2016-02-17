use Mix.Config

config :guerilla_radio, GuerillaRadio.Endpoint,
  secret_key_base: "secret_key_base"

config :guerilla_radio, GuerillaRadio.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "guerilla_radio_prod",
  pool_size: 20
