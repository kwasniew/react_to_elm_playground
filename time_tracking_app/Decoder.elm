module Decoder exposing (..)

import Json.Decode exposing (string, list, float, maybe, Decoder, map, field, fail, succeed, andThen)
import Json.Decode.Pipeline exposing (required, decode, hardcoded, custom)
import Types exposing (..)
import Uuid exposing (fromString, Uuid)


timersDecoder : Decoder (List Timer)
timersDecoder =
    (list timerDecoder)


decodeUuid : String -> Decoder Uuid
decodeUuid s =
    case fromString s of
        Just guid ->
            succeed guid

        Nothing ->
            fail "invalid"


timerDecoder : Decoder Timer
timerDecoder =
    decode Timer
        |> required "title" string
        |> required "project" string
        |> required "title" string
        |> required "project" string
        |> required "elapsed" float
        |> custom ((maybe (field "runningSince" float)))
        |> hardcoded False
        |> custom ((field "id" string) |> andThen decodeUuid)


noOp : Decoder String
noOp =
    succeed "done"
