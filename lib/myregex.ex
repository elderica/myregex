defmodule Myregex do
  @moduledoc """
  Documentation for Myregex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Myregex.hello
      :world

  """
  def hello do
    :world
  end

  def matchOne(nil, __) do
    true
  end

  def matchOne("", __) do
    true
  end

  def matchOne(__, nil) do
    false
  end

  def matchOne(__, "") do
    false
  end

  def matchOne(".", __) do
    true
  end

  def matchOne(pattern, text) do
    pattern == text
  end

  def match("", __) do
    true
  end

  def match(nil, __) do
    true
  end

  def match("$", "") do
    true
  end

  def match("$", nil) do
    true
  end

  def match(pattern , text) do
    # workaround for testing
    {phead, prest} = case String.next_codepoint pattern do
      nil -> {"", ""}
      t -> t
    end
    {thead, trest} = case String.next_codepoint text do
      nil -> {"", ""}
      t -> t
    end
    matchOne(phead, thead) && match(prest, trest)
  end

  def search(pattern, text) do
    if String.first(pattern) == "^" do
      match(String.slice(pattern, 1..-1), text)
    end
  end

end
