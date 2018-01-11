defmodule Myregex do
  @moduledoc """
  A simple regex module for practice.
  """

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

  def match(pattern, text) do
    # workaround for testing
    {phead, prest} = case String.next_grapheme pattern do
      nil -> {"", ""}
      t -> t
    end
    {thead, trest} = case String.next_grapheme text do
      nil -> {"", ""}
      t -> t
    end
    if String.first(prest) == "?" do
      matchQuestion(pattern, text)
    else
      matchOne(phead, thead) && match(prest, trest)
    end
  end

  def search(pattern, text) do
    cond do
      String.first(pattern) == "^" ->
        match(String.slice(pattern, 1..-1), text)
      true ->
        l = String.length text
        Enum.any?(
          0..(l-1),
          fn(i) ->
            r = String.slice(text, i..-1)
            match(pattern, r)
          end
        )
    end
  end

  def matchQuestion(pattern, text) do
    first_matched = matchOne(String.first(pattern), String.first(text))
    matched_after_question = match(String.slice(pattern, 2..-1), String.slice(text, 1..-1))
    (first_matched && matched_after_question) || match(String.slice(pattern, 2..-1), text)
  end
end
