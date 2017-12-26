defmodule Blitzy.CLI do

  def main(args) do
    Application.get_env(:blitzy, :master_node)
      |> Node.start

    Application.get_env(:blitzy, :slave_nodes)
      |> Enum.each(&Node.connect(&1))

    args
      |> parse_args
      |> process_options([node()|Node.list])
  end

  def parse_args(args) do
    OptionParser.parse(args, aliases: [n: :requests, r: :repeats, s: :scenario, o: :graph_name],
                              strict: [requests: :integer, repeats: :integer, scenario: :string, graph_name: :string])
  end

  defp process_options(options, nodes) do
    case options do
      {[requests: n, repeats: r, scenario: s], [url], []} ->
        Blitzy.Request.do_requests([], n, r, s, url, nodes,[])
      {[graph_name: o, scenario: s], [], []} ->
        Blitzy.Graph.create_graph_data(s)
        |> Blitzy.Graph.create_graph(s,o)
      _ ->
        do_help()

    end
  end

  defp do_help do
    IO.puts """
    Usage:
    blitzy -n [requests] -r [repeats] -s [scenario] [url]

    Options:
    -n, [--requests]      # Number of requests
    -r, [--repeats]       # Number of repeats
    -s, [--scenario]      # Your scenario module function
    -o, [--graph_name]    # output graph file name

    Example:
    ./blitzy -n 100 -r 2 -s get http://www.bieberfever.com
    ./blitzy -o graph_step_01.html -s step_01
    """
    System.halt(0)
  end

end
