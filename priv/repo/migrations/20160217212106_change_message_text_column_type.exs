defmodule GuerillaRadio.Repo.Migrations.ChangeMessageTextColumnType do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      modify :text, :text
    end
  end
end
