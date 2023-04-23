-module(yoyo_client_erl).

-export([req_yoyo/3]).
-export([connect_yoyo/1]).
-export([connect_yoyo/2]).


% API

req_yoyo(Command, Args, Sock) ->
    Msg = make_req(Command, Args),
    send_req(Msg, Sock),
    {ok, Data} = recv_req(Sock),
    Data.

connect_yoyo(IP) ->
    Option= [{active, true}, {packet, 4}],
    {ok, Sock} = gen_tcp:connect(IP, 9989, Option),
    Sock.

connect_yoyo(IP, Port) ->
    Option= [{active, true}, {packet, 4}],
    {ok, Sock} = gen_tcp:connect(IP, Port, Option),
    Sock.

%% Internal

make_req(Command, Args)->
    Dic = [Command, Args],
    Msg = jiffy:encode(Dic),
    Msg.

send_req(Msg, Sock)->
    gen_tcp:send(Sock, Msg).

recv_req(Sock) ->
    receive
        {tcp, Sock, Data} ->
            ErlData = jiffy:decode(Data),
            % inet:setopts(Sock, [{active, once}, 
            % {packet, 4}]),
            {ok, ErlData};
        {tcp_close, Sock} ->
            {error, "Sim clinet close ! ~n"}
    end.