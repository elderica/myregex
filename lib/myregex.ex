defmodule Myregex do
  @moduledoc """
  A simple regex module for practice.
  """

  def matchOne(pattern, text) do
    case {pattern, text} do
      {"", _} -> true
      {nil, _} -> true
      {_, ""} -> false
      {_, nil} -> false
      {_, _} ->
        pattern == "." || text == pattern
    end
  end

  def search(pattern, text) do
    cond do
      String.first(pattern) == "^" ->
        match(String.slice(pattern, 1..-1), text)
      true ->
        match(".*" <> pattern, text)
    end
  end

  def match(pattern, text) do
    cond do
      pattern == "" -> true
      pattern == nil -> true
      pattern == "$" && text == "" -> true
      pattern == "$" && text == "" -> true
      String.at(pattern, 1) == "?" ->
        matchQuestion(pattern, text)
      String.at(pattern, 1) == "*" ->
        matchStar(pattern, text)
      String.first(pattern) == "(" ->
        matchGroup(pattern, text)
      true ->
        {pcar, pcdr} = String.next_grapheme(pattern)
        {tcar, tcdr} = case String.next_grapheme(text) do
          nil -> {"", ""}
          x -> x
        end
        matchOne(pcar, tcar) && match(pcdr, tcdr)
    end
  end

  def matchQuestion(pattern, text) do
    pcar = String.first(pattern)
    pcddr = String.slice(pattern, 2..-1)
    {tcar, tcdr} = case String.next_grapheme(text) do
      nil -> {"", ""}
      x -> x
    end
    (matchOne(pcar, tcar) && match(pcddr, tcdr)) ||
      match(pcddr, text)
  end

  def matchStar(pattern, text) do
    pcar = String.first(pattern)
    pcddr = String.slice(pattern, 2..-1)
    {tcar, tcdr} = case String.next_grapheme(text) do
      nil -> {"", ""}
      {car, cdr} -> {car, cdr}
    end
    (matchOne(pcar, tcar) && match(pattern, tcdr)) ||
      match(pcddr, text)
  end

  def matchGroup(pattern, text) do
  end
end
