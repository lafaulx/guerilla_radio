defmodule GuerillaRadio.Repo.Migrations.AddHiddenColumnToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :hidden, :boolean, default: false, null: false
    end
  end
end
