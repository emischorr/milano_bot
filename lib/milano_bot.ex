defmodule MilanoBot do
  @moduledoc """
  A central module exposing the two main functionalities: fetchting the menu and sending it out.
  Although it's partly used by the scraper it's intended for manual purpose over an iex session.
  """
  alias MilanoBot.Milano.WeeklyMenu
  alias MilanoBot.Scraper

  @doc """
  Fetches the menu from the websites and returns a structured output in the form of:
  [
    %{
      day: "Montag",
      menu: ["Pizza mit frischen Champignon mittel", "Spaghetti Bolognese",
        "Verschiedene Nudeln in Sahnesoße mit Formfleischvorderschinken + Salat"]
    },
    ...
  ]
  """
  @spec fetch_menu() :: {:ok, list()} | {:error, String.t()}
  def fetch_menu, do: WeeklyMenu.fetch() |> WeeklyMenu.parse()

  @doc """
  Send the last fetched (from the point of the GenServer) menu out.
  """
  @spec send_update() :: :ok
  defdelegate send_update, to: Scraper
end
