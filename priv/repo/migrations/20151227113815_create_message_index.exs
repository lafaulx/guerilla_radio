defmodule GuerillaRadio.Repo.Migrations.CreateMessageIndex do
  use Ecto.Migration

  def change do
    create unique_index(:messages, [:ts, :channel], name: :messages_channel_ts_index)
  end
end
