module Client exposing (getTimersCommand, createTimerCommand, updateTimerCommand, startTimerCommand, stopTimerCommand, deleteTimerCommand)

import CustomHttp exposing (put, delete)
import Uuid exposing (..)
import Time exposing (..)
import Types exposing (..)
import Http
import Decoder exposing (timersDecoder, noOp)
import Encoder exposing (..)
import Helpers exposing (..)


startTimerCommand : Uuid -> Time -> Cmd Msg
startTimerCommand id now =
    Http.send Posted <|
        Http.post
            "/api/timers/start"
            (Http.stringBody
                "application/json"
                (Encoder.startTimer id now)
            )
            noOp


stopTimerCommand : Uuid -> Time -> Cmd Msg
stopTimerCommand id now =
    Http.send Posted <|
        Http.post
            "/api/timers/stop"
            (Http.stringBody
                "application/json"
                (Encoder.stopTimer id now)
            )
            noOp


createTimerCommand : Timer -> Cmd Msg
createTimerCommand timer =
    Http.send Posted <|
        Http.post
            "/api/timers"
            (Http.stringBody
                "application/json"
                (Encoder.timer timer)
            )
            noOp


updateTimerCommand : List Timer -> Uuid -> Cmd Msg
updateTimerCommand timers id =
    case findById timers id of
        Just timer ->
            Http.send Posted <|
                CustomHttp.put
                    "/api/timers"
                    (Http.stringBody
                        "application/json"
                        (Encoder.timer timer)
                    )
                    noOp

        Nothing ->
            Cmd.none


deleteTimerCommand : Uuid -> Cmd Msg
deleteTimerCommand id =
    Http.send Posted <|
        CustomHttp.delete
            "/api/timers"
            (Http.stringBody
                "application/json"
                (Encoder.delete id)
            )
            noOp


getTimersCommand : Cmd Msg
getTimersCommand =
    Http.send Fetched <| Http.get "/api/timers" timersDecoder
