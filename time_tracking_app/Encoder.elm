module Encoder exposing (..)

import Json.Encode exposing (..)
import Uuid exposing (..)
import Time exposing (..)
import Types exposing (..)


startTimer : Uuid -> Time -> String
startTimer id now =
    object
        [ ( "id", string (Uuid.toString id) )
        , ( "start", float now )
        ]
        |> encode 4


stopTimer : Uuid -> Time -> String
stopTimer id now =
    object
        [ ( "id", string (Uuid.toString id) )
        , ( "stop", float now )
        ]
        |> encode 4


timer : Timer -> String
timer timer =
    object
        [ ( "title", string timer.title )
        , ( "project", string timer.project )
        , ( "id", string (Uuid.toString timer.id) )
        , ( "elapsed", float timer.elapsed )
        ]
        |> encode 4
