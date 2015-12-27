defmodule GuerillaRadio.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :channel, :string
      add :user, :string
      add :text, :string
      add :ts, :string
    end

  end
end
