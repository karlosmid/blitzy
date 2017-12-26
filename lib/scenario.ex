defmodule Blitzy.Scenarios do  
  
  @headers %{"Accept-Encoding" => "gzip, deflate, br","Accept-Language" => "hr-HR,hr;q=0.8,en-US;q=0.6,en;q=0.4",
               "User-Agent" => "blitzy", "Content-Type" => "application/json;charset=UTF-8",
               "Accept" => "application/json, text/plain, */*", "Connection" => "keep-alive"}  

  def get url do
    Blitzy.Measure.duration_of_http_poison(fn -> HTTPoison.get(url,[],headers: @headers, hackney: [:insecure]) end, "get")
  end
  
  def get_mock url do
    Blitzy.Measure.duration_of_http_poison(fn -> HTTPoison.get(url) end, "get_mock")
  end
  
  def scenario_01 url do
    results = []
    results = [step_01(url)|results]
    results = [step_02(url)|results]
    results
  end

  defp step_01 url do
    Blitzy.Measure.duration_of_http_poison(fn -> HTTPoison.get(url, [], params: %{s: "selenium"}) end, "step_01")
    
  end
  defp step_02 url do
    Blitzy.Measure.duration_of_http_poison(fn -> HTTPoison.get(url, [], params: %{s: "grinder"}) end, "step_02")
  end
    
end
