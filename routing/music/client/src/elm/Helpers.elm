module Helpers exposing (durationToHuman)


durationToHuman : Int -> String
durationToHuman ms =
    let
        seconds =
            (ms // 1000) % 60

        minutes =
            (ms // 1000 // 60) % 60

        hours =
            (ms // 1000 // 60 // 60)

        paddedSeconds =
            String.padLeft 2 '0' (toString seconds)

        paddedMinutes =
            String.padLeft 2 '0' (toString minutes)
    in
        if hours > 0 then
            toString hours ++ ":" ++ paddedMinutes ++ ":" ++ paddedSeconds
        else
            toString minutes ++ ":" ++ paddedSeconds
