-module(transports).

-export([start_worker/2]).


start_worker(Socket, ID) ->
    Pid = spawn(fun() -> accepter(Socket, ID) end),
    {ok, Pid}.


accepter(Listen, ID) ->
    io:format("INFO: listen ~p is listening ~n", [ID]),
    {ok, Socket} = gen_tcp:accept(Listen),
    io:format("~B get socket ~n", [ID]),
    Controller = spawn(fun() -> receiver(Socket) end),
    ok = gen_tcp:controlling_process(Socket, Controller),
    accepter(Listen, ID). 


receiver(Socket) ->
    receive
        {tcp, Socket, Data} -> 
            tcp_middleware:handle_data(Data, Socket),
            inet:setopts(Socket, [{active, once}, 
                {packet, 4}]),
            receiver(Socket);
        {tcp_closed, Socket} ->
            io:format("INFO: socket closed  ~p ~n", [[Socket]]),
            io:format("INFO: receiver process end ~n")
    end.

