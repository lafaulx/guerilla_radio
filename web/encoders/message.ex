defimpl Poison.Encoder, for: GuerillaRadio.Message do
  def encode(model, opts) do
    model
      |> Map.take([:id, :user, :channel, :text, :ts])
      |> Poison.Encoder.encode(opts)
  end
end