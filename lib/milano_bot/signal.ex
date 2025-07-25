defmodule MilanoBot.Signal do
  @spec send(String.t()) :: any()
  def send(message) do
    "#{signal_config(:api_url)}/v2/send"
    |> Req.post(
      json: %{
        number: signal_config(:sender),
        recipients: ["group.#{signal_config(:group)}"],
        message: message
      }
    )
    |> IO.inspect()
    |> case do
      {:ok, resp} -> resp
      {:error, error} -> error
    end
  end

  def signal_config(key), do: Application.get_env(:milano_bot, :signal) |> Keyword.get(key)
end
