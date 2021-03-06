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


type alias Thread =
    { id : String
    , title : String
    , messages : List Message
    }


type alias Model =
    { threads : List Thread
    , activeThreadId : String
    , message : String
    , currentUuid : ( Seed, Uuid )
    }


init : Int -> ( Model, Cmd Msg )
init seed =
    let
        ( newUuid, newSeed ) =
            Random.Pcg.step Uuid.uuidGenerator (initialSeed seed)
    in
        ( { threads =
                [ { id = "1-fca2"
                  , title = "Buzz Aldrin"
                  , messages = []
                  }
                , { id = "2-be91"
                  , title = "Michael Collins"
                  , messages = []
                  }
                ]
          , activeThreadId = "1-fca2"
          , message = ""
          , currentUuid = ( newSeed, newUuid )
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

        DeleteMessage id ->
            ( { model | threads = deleteMessage model id }, Cmd.none )

        UpdateMessageText text ->
            ( { model | message = text }, Cmd.none )

        NewTime time ->
            let
                ( newUuid, newSeed ) =
                    Random.Pcg.step Uuid.uuidGenerator (Tuple.first model.currentUuid)

                message =
                    Message model.message time (Tuple.second model.currentUuid)
            in
                ( { model
                    | threads = newMessage model message
                    , message = ""
                    , currentUuid = ( newSeed, newUuid )
                  }
                , Cmd.none
                )

        OpenThread id ->
            ( { model | activeThreadId = id }, Cmd.none )


inActiveThread : Model -> (Thread -> Thread) -> List Thread
inActiveThread model update =
    List.map
        (\thread ->
            if thread.id == model.activeThreadId then
                update thread
            else
                thread
        )
        model.threads


newMessage : Model -> Message -> List Thread
newMessage model message =
    inActiveThread model
        (\thread -> { thread | messages = thread.messages ++ [ message ] })


deleteMessage : Model -> Uuid -> List Thread
deleteMessage model id =
    inActiveThread model
        (\thread -> { thread | messages = List.filter (\message -> message.id /= id) thread.messages })


type Msg
    = AddMessage
    | DeleteMessage Uuid
    | UpdateMessageText String
    | NewTime Time
    | OpenThread String


messageList : List Message -> (Uuid -> msg) -> Html msg
messageList messages onClickMsg =
    div [ class "ui comments" ]
        (List.map
            (\message ->
                div []
                    [ div [ class "comment", onClick (onClickMsg message.id) ]
                        [ div [ class "text" ]
                            [ text message.text
                            , span [ class "metadata" ]
                                [ text <| "@" ++ (toString message.timestamp)
                                ]
                            ]
                        ]
                    ]
            )
            messages
        )



--  generic text field with record param


textFieldSubmit : { message : String, onClickMsg : msg, onInputMsg : String -> msg } -> Html msg
textFieldSubmit config =
    div [ class "ui input" ]
        [ input [ type_ "text", onInput config.onInputMsg, value config.message ] []
        , button [ class "ui primary button", onClick config.onClickMsg, type_ "submit" ] [ text "submit" ]
        ]


thread : String -> Thread -> Html Msg
thread message activeThread =
    div [ class "comment" ]
        [ messageList activeThread.messages DeleteMessage
        , textFieldSubmit { message = message, onClickMsg = AddMessage, onInputMsg = UpdateMessageText }
        ]


active : Thread -> String -> Bool
active thread id =
    thread.id == id


threadTabs : Model -> Html Msg
threadTabs model =
    tabs
        (TabConfig
            (List.map
                (\thread ->
                    Tab
                        (active thread model.activeThreadId)
                        thread.title
                        thread.id
                )
                model.threads
            )
            OpenThread
        )



--  generic tabs with type alias param


type alias TabConfig msg =
    { tabs : List Tab
    , onClick : String -> msg
    }


type alias Tab =
    { active : Bool
    , title : String
    , id : String
    }


tabs : TabConfig msg -> Html msg
tabs config =
    div [ class "ui top attached tabular menu" ]
        (List.map
            (\tab ->
                div
                    [ class
                        (if tab.active then
                            "active item"
                         else
                            "item"
                        )
                    , onClick (config.onClick tab.id)
                    ]
                    [ text tab.title ]
            )
            config.tabs
        )


threadDisplay : Model -> List (Html Msg)
threadDisplay model =
    (List.filter
        (\thread -> thread.id == model.activeThreadId)
        model.threads
        |> List.map (thread model.message)
    )


view : Model -> Html Msg
view model =
    div [ class "ui segment" ]
        (threadTabs model :: threadDisplay model)


main : Program Int Model Msg
main =
    programWithFlags { init = init, update = update, view = view, subscriptions = (\_ -> Sub.none) }
