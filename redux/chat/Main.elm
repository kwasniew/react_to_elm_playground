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


threadsReducer : Msg -> Model -> List Thread
threadsReducer msg model =
    case msg of
        DeleteMessage id ->
            deleteMessage model id

        NewTime time ->
            let
                message =
                    Message model.message time (Tuple.second model.currentUuid)
            in
                newMessage model message

        _ ->
            model.threads


activeThreadIdReducer : Msg -> String -> String
activeThreadIdReducer msg current =
    case msg of
        OpenThread id ->
            id

        _ ->
            current


messageReducer : Msg -> String -> String
messageReducer msg current =
    case msg of
        UpdateMessageText text ->
            text

        NewTime _ ->
            ""

        _ ->
            current


currentUuidReducer : Msg -> ( Seed, Uuid ) -> ( Seed, Uuid )
currentUuidReducer msg current =
    case msg of
        NewTime _ ->
            let
                ( newUuid, newSeed ) =
                    Random.Pcg.step Uuid.uuidGenerator (Tuple.first current)
            in
                ( newSeed, newUuid )

        _ ->
            current


commandReducer : Msg -> Cmd Msg
commandReducer msg =
    case msg of
        AddMessage ->
            now

        _ ->
            Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model
        | threads = threadsReducer msg model
        , activeThreadId = activeThreadIdReducer msg model.activeThreadId
        , message = messageReducer msg model.message
        , currentUuid = currentUuidReducer msg model.currentUuid
      }
    , commandReducer msg
    )


xupdate : Msg -> Model -> ( Model, Cmd Msg )
xupdate msg model =
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


messageView : List Message -> Html Msg
messageView messages =
    div [ class "ui comments" ]
        (List.map
            (\message ->
                div []
                    [ div [ class "comment", onClick (DeleteMessage message.id) ]
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


messageInput : String -> Html Msg
messageInput message =
    div [ class "ui input" ]
        [ input [ type_ "text", onInput UpdateMessageText, value message ] []
        , button [ class "ui primary button", onClick AddMessage, type_ "submit" ] [ text "submit" ]
        ]


thread : String -> Thread -> Html Msg
thread message t =
    div [ class "comment" ]
        [ messageView t.messages
        , messageInput message
        ]


tabClass : Thread -> String -> String
tabClass thread id =
    if thread.id == id then
        "active item"
    else
        "item"


threadTabs : Model -> Html Msg
threadTabs model =
    div [ class "ui top attached tabular menu" ]
        (List.map
            (\thread ->
                div [ class <| tabClass thread model.activeThreadId, onClick (OpenThread thread.id) ]
                    [ text thread.title ]
            )
            model.threads
        )


view : Model -> Html Msg
view model =
    div [ class "ui segment" ]
        (threadTabs model
            :: (List.filter
                    (\thread -> thread.id == model.activeThreadId)
                    model.threads
                    |> List.map (thread model.message)
               )
        )


main : Program Int Model Msg
main =
    programWithFlags { init = init, update = update, view = view, subscriptions = (\_ -> Sub.none) }
