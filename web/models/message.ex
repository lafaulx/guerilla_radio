defmodule GuerillaRadio.Message do
  use GuerillaRadio.Web, :model

  schema "messages" do
    field :channel, :string
    field :user, :string
    field :text, :string
    field :ts, :float
    field :hidden, :boolean, default: false
  end

  @required_fields ~w(channel user text ts)
  @optional_fields ~w(hidden)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast(params, ~w(ts), ~w())
    |> unique_constraint(:ts, name: :messages_channel_ts_index)
  end
end
