-module(simple_example).
-export([start_game/0]).

-define(SIM_PORT, 8888).
-define(ENGINE_PORT, 9989).
-define(ENGINE_IP, "127.0.0.1").
-define(MAX_STEP, 10).
-define(SPEED, 1).

%% API
start_game() ->
    Sock = yoyo_client_erl:connect_yoyo(?ENGINE_IP, ?ENGINE_PORT),
    UUid = req_make_task(Sock),
    req_config_sim(Sock, UUid),
    req_make_dep(Sock, UUid),
    req_start(Sock, UUid, ?MAX_STEP, ?SPEED).

%% Internal
req_make_task(Sock) ->
    % make task 
    Args = [
        {[
            {<<"Sid_1">>, [<<"127.0.0.1">>, ?SIM_PORT]}
        ]}
    ],
    Data = yoyo_client_erl:req_yoyo(<<"make_task">>, Args, Sock),
    io:format(" make_task res is ~p ~n", [Data]),
    [_, UUid] = Data,
    UUid.

req_config_sim(Sock, UUid)->
    % config sim
    SimArgs = {[
        {<<"Sid_1">>, []}
    ]},
    Args = [UUid, SimArgs],
    _Data = yoyo_client_erl:req_yoyo(<<"config_sim">>, Args, Sock).

req_make_dep(Sock, UUid) ->
    %  make_dep
    DepDic = {[
        {<<"Sid_1">>, []}
    ]},
    Args = [UUid, DepDic],
    yoyo_client_erl:req_yoyo(<<"make_dep">>, Args, Sock).

req_start(Sock, UUid, MaxStep, Speed) ->
    % start
    Args = [UUid, MaxStep, Speed],
    yoyo_client_erl:req_yoyo(<<"start">>, Args, Sock).


