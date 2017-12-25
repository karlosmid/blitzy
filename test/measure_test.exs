defmodule BlitzyMeasureTest do
  use ExUnit.Case
  doctest Blitzy
  import Blitzy.Measure
  import Mock

  test "duration of ok http poison" do
    with_mock HTTPoison,
        [get: fn("http://example.com") ->
            {:ok, %HTTPoison.Response{status_code: 200}} end] do
            actual = duration_of_http_poison(fn -> HTTPoison.get("http://example.com") end,"name")
            assert elem(actual,0) == :ok
            assert elem(actual,1) >= 0.0
            assert elem(actual,2) == 200
            assert elem(actual,3) > 0
            assert elem(actual,4) == "name"
    end
  end
  test "duration of http error with :ok" do
    with_mock HTTPoison,
        [get: fn("http://ok.example.com") ->
            {:ok, %HTTPoison.Response{status_code: 404}} end] do
            actual = duration_of_http_poison(fn -> HTTPoison.get("http://ok.example.com") end,"name")
            assert elem(actual,0) == :error
            assert elem(actual,1) >= 0.0
            assert elem(actual,2) == 404
            assert elem(actual,3) > 0
            assert elem(actual,4) == "name"
    end
  end
  test "duration of http error" do
    with_mock HTTPoison,
        [get: fn("http://error.example.com") ->
            {:error, %HTTPoison.Response{status_code: 400}} end] do
            actual = duration_of_http_poison(fn -> HTTPoison.get("http://error.example.com") end,"name")
            assert elem(actual,0) == :error
            assert elem(actual,1) >= 0.0
            assert elem(actual,2) == 400
            assert elem(actual,3) > 0
            assert elem(actual,4) == "name"
    end
  end
  
  test "duration of known error" do
    with_mock HTTPoison,
        [get: fn("http://known.example.com") ->
            {:error, %HTTPoison.Error{reason: 'nxdomain'}} end] do
            actual = duration_of_http_poison(fn -> HTTPoison.get("http://known.example.com") end,"name")
            assert elem(actual,0) == :error
            assert elem(actual,1) >= 0.0
            assert elem(actual,2) == 'nxdomain'
            assert elem(actual,3) > 0
            assert elem(actual,4) == "name"
    end
  end
  test "duration of unknown error" do
    with_mock HTTPoison,
        [get: fn("http://unknown.example.com") ->
            {:error} end] do
            actual = duration_of_http_poison(fn -> HTTPoison.get("http://unknown.example.com") end,"name")
            assert elem(actual,0) == :error
            assert elem(actual,1) >= 0.0
            assert elem(actual,2) == :unknown
            assert elem(actual,3) > 0
            assert elem(actual,4) == "name"
    end
  end
end
