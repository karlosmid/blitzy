Blitzy - A not so simple HTTP load tester in Elixir
============================================

![](http://i.imgur.com/Z8zyXZu.gif)

Inspired by this [post](http://www.watchsumo.com/posts/introduction-to-elixir-v1-0-0-by-example-i) by Victor Martinez of WatchSumo.

```
% ./blitzy -n 100 -r 2 -s get http://www.bieberfever.com
```

## Distributed Blitzy

It is _way_ more fun to start distributed. Edit the provided `config/config.exs` with whatever node name suits your fancy. This is optional, and you can stick to the provided one.

```elixir
config :blitz, master_node: :"a@127.0.0.1"

config :blitz, slave_nodes: [:"b@127.0.0.1", 
                             :"c@127.0.0.1",
                             :"d@127.0.0.1"] 
```

Here, the master node is `:a@127.0.0.1`; the rest are slave nodes.

Start up a couple of nodes, and name them accordingly. For example, here's how to start one of them:

```
% iex --name b@127.0.0.1 -S mix
```

Now, when you run the the command

```
% ./blitzy -n 2 -r 2 -s get http://www.bieberfever.com
```

the requests will be split across the number of nodes you created, including the master node. Here's an example run:

```
11:36:10.961 [info]  Protocol 'inet_tcp': register/listen error: econnrefused


11:36:12.116 [info]  worker [nonode@nohost-#PID<0.102.0>] completed in 1092.0 msecs with code 200

11:36:12.116 [info]  worker [nonode@nohost-#PID<0.101.0>] completed in 1092.0 msecs with code 403

11:36:12.116 [info]  worker [nonode@nohost-#PID<0.110.0>] completed in 0.0 msecs with code 200

11:36:12.116 [info]  worker [nonode@nohost-#PID<0.111.0>] completed in 0.0 msecs with code 403

11:36:12.116 [info]  Finished pummelling http://www.bieberfever.com with get scenario and with 2 workers for 1 times over 1 nodes.
Total requests    : 4
Total workers    : 2
Successful reqs  : 4
Failed reqs      : 0
Average (msecs)  : 546.0
Longest (msecs)  : 1092.0
Shortest (msecs) : 0.0
RPS (secs)       : 3.558718861209964


15:00:34.574 [info]  worker [b@127.0.0.1-#PID<0.178.0>] completed in 517.94 msecs

15:00:35.105 [info]  worker [b@127.0.0.1-#PID<0.185.0>] completed in 326.516 msecs
```

## Scenarios with several request

`lib\scenario.ex` contains examples how to write scenario with several steps.  
Every step (http request) should have unique name, otherwise it will not be possible to create html report for that particular request.  
Consult [httpoison](https://github.com/edgurgel/httpoison) documentation.  
When you are done with scenario, you need to build blitzy with `mix escript.build`

## Application secrets

Store you secrets in config/secrets.exs file.


## Results file

When blitzy is finished, it creates cummulative `results.txt` file in following format:

`ok,0.0,200,1485254172116,get`

Field description: http request result :ok or :error, duration in milliseconds, http status code, request start timestamp as epoch, scenario method name

Generate report

When run is done:  

`./blitzy -o report_name.html -s scenario_name`  

Here is one report ![](graph_example.png)

## Contribute

```
install latest elixir for you os
mix local.hex
mix deps.get
mix escript.build
```
### Run tests

`MIX_ENV=test mix coveralls.html`

`open cover/excoveralls.html`

### Git

```
create branch in github
git fetch
git checkout branch_name
git push
create pull request using github
```

### Notes

```
create tests for your contribution
run tests
```
