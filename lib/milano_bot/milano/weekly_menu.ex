defmodule MilanoBot.Milano.WeeklyMenu do
  @url "https://app.mahlzeit.io/snippet/widget-menu/ristorante-pizzeria-milano/mahlzeit-menu.js"

  def fetch(url \\ @url) do
    Req.new(url: url, compress_body: true)
    |> Req.Request.put_header(
      "Cookie",
      "PHPSESSID=3c78dbfe20e8f2fa60d09f4c3693142d"
    )
    |> Req.get()
    |> handle_response()

    # |> write_to_file("menu.html")
  end

  def parse({:error, error}), do: {:error, "Could not parse content: #{inspect(error)}"}

  def parse({:ok, body}) do
    Regex.run(~r/menuHtmlContent = \"(.*)/, body, capture: :all_but_first)
    |> List.first()
    |> decode_unicode()
    |> extract_content()
    |> wrap()
  end

  defp extract_content(html) do
    html
    |> Floki.parse_document()
    |> case do
      {:ok, parsed_html} ->
        parsed_html
        |> Floki.find("table")
        |> Enum.map(fn {_tag, _attr, content} ->
          %{day: day(content), menu: menu(content)}
        end)

      {:error, error} ->
        error
    end
  end

  defp day(parsed_content) do
    {_tag, _attr, [day]} = Floki.find(parsed_content, "tr>td>h3") |> List.first()
    day
  end

  defp menu(parsed_content) do
    parsed_content
    |> Floki.find("tr td div")
    |> Enum.map(fn {_tag, _attr, [content]} -> String.replace(content, ~r/^\d+ /, "") end)
  end

  defp decode_unicode(input) do
    String.replace(input, ~r/\\u([0-9A-Fa-f]{4})/, fn match ->
      <<String.to_integer(String.slice(match, 2..5), 16)::utf8>>
    end)
    |> String.replace("\\/", "/")
  end

  defp wrap(list) when is_list(list), do: {:ok, list}
  defp wrap(error) when is_binary(error), do: {:error, error}

  defp handle_response({:ok, %Req.Response{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({:ok, %Req.Response{status: status}}), do: {:error, status}
  defp handle_response({:error, error}), do: {:error, error}

  # defp write_to_file({:ok, body}, file_path) do
  #   File.write(file_path, body)
  #   {:ok, body}
  # end
end
