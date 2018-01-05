defmodule MyregexTest do
  use ExUnit.Case
  doctest Myregex

  test "matchOne: should return true when the text matches the pattern." do
    assert Myregex.matchOne("a", "a")
  end

  test "matchOne: should return true when the pattern is empty or undefined" do
    assert Myregex.matchOne("", "")
    assert Myregex.matchOne(nil, "")
  end

  test "matchOne: should return false when the text is an empty string or undefined but the pattern is defined" do
    refute Myregex.matchOne("b", "")
    refute Myregex.matchOne("b", nil)
  end

  test "matchOne: should return false when the text does not match the pattern" do
    refute Myregex.matchOne("a", "c")
  end

  test "matchOne: should match any character against a '.'" do
    assert Myregex.matchOne(".", "c")
    assert Myregex.matchOne(".", "q")
  end

  test "match: should return true if given an empty pattern" do
    assert Myregex.match("", "abc")
    assert Myregex.match("", "cab")
  end

  test "match: should match an empty string to the end of line pattern '$'" do
    assert Myregex.match("$", "")
    refute Myregex.match("$", "abc")
  end

  test "match: should match an exact sequence of characters" do
    assert Myregex.match("abc", "abc")
    assert Myregex.match("bac", "bac")
  end

  test "match: should match an exact sequence of characters with wildcards" do
    assert Myregex.match("a.c", "abc")
    assert Myregex.match("b.c", "bac")
  end

  search_with_caret = "search: patterns starting with '^'"

  test "#{search_with_caret} should match a longer sequence of characters" do
    assert Myregex.search("^please work", "please work")
  end

  test "#{search_with_caret} should still support the wildcard character '.'" do
    assert Myregex.search("^a good t.st", "a good test")
    assert Myregex.search("^an.ther g..d test", "another good test")
    refute Myregex.search("^b.d test", "baad test")
  end

  test "#{search_with_caret} should still support end of string character '$'" do
    assert Myregex.search("^match end$", "match end")
    refute Myregex.search("^match$", "match end")
  end

  test "#{search_with_caret} should support partial matches" do
    assert Myregex.search("^partial", "partial match")
    assert Myregex.search("^good", "good test")
    refute Myregex.search("^bad", "ba test")
  end

  search_without_caret = "search: patterns not starting with '^'"

  test "#{search_without_caret} should match a sequence of characters starting at any position inside the text" do
    assert Myregex.search("match", "this is a match")
    assert Myregex.search("what", "this is what we are doing")
    assert Myregex.search("is what", "this is what we are doing")
    refute Myregex.search("blah", "this is what we are doing")
    refute Myregex.search("iswhat", "this is what we are doing")
  end

  test "#{search_without_caret} returns the expected result if text is an empty string" do
    refute Myregex.search("pattern", "")
    assert Myregex.search("", "")
    assert Myregex.search("$", "")
  end

  search_with_question = "search: should match 0 or 1 of the following character a '?'"

  test "#{search_with_question} matches 0 characters if none are present" do
    assert Myregex.search("a?", "")
    assert Myregex.search("a?", "b")
  end

  test "#{search_with_question} matches 0 characters inside a larger string" do
    assert Myregex.search("thi?s", "ths")
    assert Myregex.search("this is?", "this i")
    refute Myregex.search("this is? it", "this i")
  end

  test "#{search_with_question} matches 1 character if it is present" do 
    assert Myregex.search("a?", "a")
    assert Myregex.search("b?", "b")
  end

  test "#{search_with_question} matches 1 character inside a larger string" do
    assert Myregex.search("one?", "one")
    assert Myregex.search("one? of us", "one of us")
    refute Myregex.search("is it one? of us", "is it one")
  end

  test "#{search_with_question} " do
    assert Myregex.search("is? it? r?e?a?lly", "is it really")
    assert Myregex.search("is? it? r?e?a?lly", "i i lly")
    refute Myregex.search("is? it? r?e?a?lly", "i i ly")
  end

  search_with_star = "search: should match 0 or more characters following an '*'"

  test "#{search_with_star} matches 0 characters if none are present" do
    assert Myregex.search("a*", "")
    assert Myregex.search("a*", "b")
    assert Myregex.search("b*", "aaaaa")
  end

  test "#{search_with_star} one to many many characters" do
    assert Myregex.search("a*", "a")
    assert Myregex.search("a*", "aaaaa")
  end

  test "#{search_with_star} is not overly greedy" do
    assert Myregex.search("a*", "aaaaa")
  end

  test "#{search_with_star} works with multiple '*' characters" do
    assert Myregex.search("this* i*s the str*ing", "thissss s the strrring")
    refute Myregex.search("this* i*s the str*ing", "thissss i the strrrng")
    refute Myregex.search("this* i*s the str*ing", "thissss i the srrrng")
  end

  search_with_grouping = "search: grouping"

  test "#{search_with_grouping} matches all characters placed within grouping operators" do
    assert Myregex.search("(the)", "the")
    assert Myregex.search("i am (the) hulk", "i am the hulk")
    refute Myregex.search("(th.e)", "the")
  end

  test "#{search_with_grouping} allows the ? metacharacter to apply to groups" do
    assert Myregex.search("(the)?", "")
    assert Myregex.search("(the)?", "the")
    assert Myregex.search("i am (the)? hulk", "i am  hulk")
    assert Myregex.search("i am (the)? hulk", "i am the hulk")
    refute Myregex.search("i am (the)? hulk", "i am hulk")
  end

  test "#{search_with_grouping} allows the * metacharacter to apply to groups" do
    assert Myregex.search("(the)*", "")
    assert Myregex.search("(the)*", "the")
    assert Myregex.search("(the)*", "thethe")
    assert Myregex.search("i am (the)* hulk", "i am the hulk")
    refute Myregex.search("i am (the)*e hulk", "i am the hulk")
  end

  test "#{search_with_grouping} supports multiple groupings in a single pattern" do
    assert Myregex.search("i went (to)? (school)* last (sunday)*", "i went to school last sunday")
    assert Myregex.search("i went (to)? (school)* last (sunday)*", "i went  schoolschoolschool last ")
    refute Myregex.search("i went (to)? (school)* last (sunday)* l", "i went  schoolschoolschool last ")
    refute Myregex.search("i went (to)? (school)* last (sunday)", "i went  schoolschoolschool last ")
  end

end
