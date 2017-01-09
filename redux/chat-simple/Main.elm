module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { messages : List String
    , message : String
    }


model : Model
model =
    { messages = []
    , message = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddMessage ->
            { model | messages = model.messages ++ [ model.message ], message = "" }

        DeleteMessage i ->
            { model | messages = (List.take i model.messages) ++ (List.drop (i + 1) model.messages) }

        UpdateMessageText text ->
            { model | message = text }


type Msg
    = AddMessage
    | DeleteMessage Int
    | UpdateMessageText String


messageView : List String -> Html Msg
messageView messages =
    div [ class "ui comments" ]
        (List.indexedMap
            (\index message ->
                div []
                    [ div [ class "comment", onClick (DeleteMessage index) ] [ text message ]
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


main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }
