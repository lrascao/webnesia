%% @author Bruno Pedro <bpedro@tarpipe.com>
%% @copyright 2010 tarpipe.com.

%% @doc Supervisor for the webnesia application.

-module(webnesia_sup).
-author('Bruno Pedro <bpedro@tarpipe.com>').

-behaviour(supervisor).

%% External exports
-export([start_link/0]).

%% supervisor callbacks
-export([init/1]).

%% @spec start_link() -> ServerRet
%% @doc API for starting the supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @spec init([]) -> SupervisorTree
%% @doc supervisor callback.
init([]) ->
    WebConfig = [{ip, {0,0,0,0}},
                 {port, 8080},
                 {docroot, "priv/www"}],
    Strategy = {one_for_one, 10, 10},
    {ok, {Strategy, [{webnesia_web,
                      {webnesia_web, start_link, [WebConfig]},
                      permanent, 5000, worker, dynamic}]}}.

%%
%% Tests
%%
-include_lib("eunit/include/eunit.hrl").
-ifdef(TEST).
-endif.
