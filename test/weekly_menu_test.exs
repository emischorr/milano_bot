defmodule WeeklyMenuTest do
  use ExUnit.Case

  alias MilanoBot.Milano.WeeklyMenu

  @fixture_file "test/fixtures/menu.js"

  test "WeeklyMenu.parse/1 can extract content from the javascript file" do
    result =
      @fixture_file
      |> File.read()
      |> WeeklyMenu.parse()

    assert {:ok, menu} = result
    assert length(menu) == 4
    assert %{day: "Montag", menu: monday_menu} = List.first(menu)
    assert length(monday_menu) == 3
    assert List.first(monday_menu) == "Pizza mit frischen Champignon mittel"
  end

  test "WeeklyMenu.parse/1 can deal with errors" do
    assert WeeklyMenu.parse({:error, :timeout}) == {:error, "Could not parse content: :timeout"}
  end
end
