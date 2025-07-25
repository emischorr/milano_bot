defmodule MilanoBot.Scraper do
  alias MilanoBot.Signal
  use GenServer
  require Logger

  alias MilanoBot.Signal

  # Client

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def send_update do
    GenServer.cast(__MODULE__, :send_update)
  end

  # Server (callbacks)

  @impl true
  def init(_opts) do
    Logger.info("Starting Scraper")
    Process.send_after(self(), :update, 1000)
    {:ok, %{menu_hash: nil, menu: nil}}
  end

  @impl true
  def handle_cast(:send_update, %{menu: menu} = state) do
    send_out(menu)
    {:noreply, state}
  end

  @impl true
  def handle_info(:update, state) do
    Logger.info("Updating menu from website")
    Process.send_after(self(), :update, update_interval())

    new_state =
      case MilanoBot.fetch_menu() do
        {:ok, menu} -> update_and_publish(state, menu)
        {:error, desc} -> handle_error(state, desc)
      end

    {:noreply, new_state}
  end

  defp update_and_publish(%{menu_hash: old_hash} = state, menu) do
    new_hash =
      menu
      |> Enum.map(&inspect/1)
      |> Enum.join()
      |> hash()

    if old_hash != nil && old_hash != new_hash, do: send_out(menu)
    %{state | menu_hash: new_hash, menu: menu}
  end

  defp send_out(menu) do
    Logger.info("Sending out menu")

    menu
    |> format()
    |> Signal.send()
  end

  defp format(menu_list) do
    menu_list
    |> Enum.map(fn %{day: day, menu: menu} ->
      """
      #{day}
      - #{Enum.join(menu, "\n- ")}
      """
    end)
    |> Enum.join("\n\n")
  end

  defp handle_error(state, desc) do
    Logger.warning(desc)
    state
  end

  defp hash(string), do: :sha256 |> :crypto.hash(string) |> Base.encode16(case: :lower)

  defp update_interval, do: Application.get_env(:milano_bot, :update_interval, :timer.hours(2))
end
