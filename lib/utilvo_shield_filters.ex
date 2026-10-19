defmodule UtilvoShieldFilters do
  @moduledoc """
  Zero-dependency parser and domain suffix matcher for Adblock Plus 2.0 (`[Adblock Plus 2.0]`)
  and uBlock Origin static network filter rules.
  """

  @filter_list_url "https://utilvo.com/filters/utilvo-shield-filters.txt"
  @mirror_filter_list_url "https://utilvo.com/shield/filters.txt"
  @shield_homepage "https://utilvo.com/shield"

  def filter_list_url, do: @filter_list_url
  def mirror_filter_list_url, do: @mirror_filter_list_url
  def shield_homepage, do: @shield_homepage

  @doc """
  Parses a single Adblock Plus 2.0 network rule line (`||domain^$third-party`).
  Returns `{:ok, %{domain: String.t(), third_party: boolean(), excluded_domains: [String.t()]}}`
  or `:error`.
  """
  def parse_abp_rule(line) when is_binary(line) do
    trimmed = String.trim(line)

    cond do
      trimmed == "" ->
        :error

      String.starts_with?(trimmed, ["!", "["]) ->
        :error

      not String.starts_with?(trimmed, "||") ->
        :error

      true ->
        case :binary.match(trimmed, "^") do
          {caret_idx, 1} when caret_idx > 2 ->
            domain =
              trimmed
              |> binary_part(2, caret_idx - 2)
              |> String.downcase()

            options_str = binary_part(trimmed, caret_idx + 1, byte_size(trimmed) - caret_idx - 1)
            {third_party, excluded} = parse_options(options_str)

            {:ok,
             %{
               domain: domain,
               third_party: third_party,
               excluded_domains: excluded
             }}

          _ ->
            :error
        end
    end
  end

  defp parse_options("$" <> rest) do
    opts = String.split(rest, ",", trim: true)

    Enum.reduce(opts, {false, []}, fn opt, {tp, ex} ->
      cond do
        opt in ["third-party", "3p"] ->
          {true, ex}

        String.starts_with?(opt, "domain=") ->
          doms =
            opt
            |> String.replace_prefix("domain=", "")
            |> String.split("|", trim: true)
            |> Enum.filter(&String.starts_with?(&1, "~"))
            |> Enum.map(&(String.replace_prefix(&1, "~", "") |> String.downcase()))
            |> Enum.reject(&(&1 == ""))

          {tp, ex ++ doms}

        true ->
          {tp, ex}
      end
    end)
  end

  defp parse_options(_), do: {false, []}

  @doc """
  Checks whether `hostname` or any of its parent registrable domains exist in `blocked_set` (a `MapSet`).
  """
  def host_blocked?(hostname, blocked_set) when is_binary(hostname) do
    clean =
      hostname
      |> String.trim()
      |> String.trim_trailing(".")
      |> String.downcase()

    parts = String.split(clean, ".", trim: true)

    if length(parts) < 2 do
      false
    else
      0..(length(parts) - 2)
      |> Enum.any?(fn idx ->
        candidate = parts |> Enum.drop(idx) |> Enum.join(".")
        MapSet.member?(blocked_set, candidate)
      end)
    end
  end
end
