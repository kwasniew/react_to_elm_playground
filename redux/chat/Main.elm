module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Task
import Time exposing (Time)
import Random.Pcg exposing (Seed, initialSeed, step)
import Uuid exposing (Uuid)


type alias Message =
    { text : String
    , timestamp : Time
    , id : Uuid
    }


type alias Model =
    { messages : List Message
    , message : String
    , currentSeed : Seed
    , currentUuid : Uuid
    }


init : Int -> ( Model, Cmd Msg )
init seed =
    let
        ( newUuid, newSeed ) =
            Random.Pcg.step Uuid.uuidGenerator (initialSeed seed)
    in
        ( { messages = []
          , message = ""
          , currentSeed = newSeed
          , currentUuid = newUuid
          }
        , Cmd.none
        )


now : Cmd Msg
now =
    Task.perform NewTime Time.now


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddMessage ->
            ( model, now )

        DeleteMessage i ->
            ( { model | messages = (List.take i model.messages) ++ (List.drop (i + 1) model.messages) }, Cmd.none )

        UpdateMessageText text ->
            ( { model | message = text }, Cmd.none )

        NewTime time ->
            let
                ( newUuid, newSeed ) =
                    Random.Pcg.step Uuid.uuidGenerator model.currentSeed

                message =
                    Message model.message time model.currentUuid
            in
                ( { model | messages = model.messages ++ [ message ] }, Cmd.none )


type Msg
    = AddMessage
    | DeleteMessage Int
    | UpdateMessageText String
    | NewTime Time


messageView : List Message -> Html Msg
messageView messages =
    div [ class "ui comments" ]
        (List.indexedMap
            (\index message ->
                div []
                    [ div [ class "comment", onClick (DeleteMessage index) ] [ text message.text ]
                    ]
            )
            messages
        )


messageInput : String -> Html Msg
messageInput message =
    div [ class "ui input" ]
        [ input [ type_ "text", onInput UpdateMessageText, value message ] []
        , button [ class "ui primary button", onClick AddMessage, type_ "submit" ] [ text "submit" ]
        ]


view : Model -> Html Msg
view model =
    div [ class "ui segment" ]
        [ messageView model.messages
        , messageInput model.message
        ]


main : Program Int Model Msg
main =
    programWithFlags { init = init, update = update, view = view, subscriptions = (\_ -> Sub.none) }
