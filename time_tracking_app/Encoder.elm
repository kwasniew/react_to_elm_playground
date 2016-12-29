module Encoder exposing (..)

import Json.Encode exposing (..)
import Uuid exposing (..)
import Time exposing (..)


startTimer : Uuid -> Time -> String
startTimer id now =
    object
        [ ( "id", string (Uuid.toString id) )
        , ( "start", float now )
        ]
        |> encode 4
