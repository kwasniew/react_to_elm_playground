module Helpers exposing (..)

import Time exposing (..)


renderElapsedString : Time -> Maybe Time -> Time -> String
renderElapsedString elapsed runningSince now =
    let
        totalElapsed =
            case runningSince of
                Just val ->
                    elapsed + now - val

                Nothing ->
                    elapsed
    in
        millisecondsToHuman totalElapsed


millisecondsToHuman : Float -> String
millisecondsToHuman ms =
    let
        seconds =
            floor (ms / 1000) % 60

        minutes =
            floor (ms / 1000 / 60) % 60

        hours =
            floor (ms / 1000 / 60 / 60)
    in
        [ pad hours, pad minutes, pad seconds ] |> String.join ":"


pad : Int -> String
pad i =
    String.padLeft 2 '0' (toString i)
