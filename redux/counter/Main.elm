module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { count : Int
    , amount : Int
    }


model : Model
model =
    { count = 0
    , amount = 1
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + model.amount }

        Decrement ->
            { model | count = model.count - model.amount }

        SetAmount amount ->
            case String.toInt amount of
                Ok a ->
                    { model | amount = a }

                _ ->
                    model


type Msg
    = Increment
    | Decrement
    | SetAmount String


view : Model -> Html Msg
view model =
    div [ class "main ui", id "main" ]
        [ h1 [ class "ui dividing centered header" ]
            [ text "Counter" ]
        , div [ id "content" ]
            [ div [ class "ui one column stackable center aligned page grid" ]
                [ div [ class "column three wide" ]
                    [ div [ class "ui cards" ]
                        [ div [ class "card" ]
                            [ div [ class "content" ]
                                [ div [ class "header" ]
                                    [ text (toString model.count) ]
                                ]
                            , div [ attribute "style" "margin:10px" ]
                                [ div [ class "ui input", attribute "style" "width:130px" ]
                                    [ input
                                        [ placeholder "Enter amount..."
                                        , type_ "text"
                                        , value (toString model.amount)
                                        , onInput SetAmount
                                        ]
                                        []
                                    ]
                                ]
                            , div [ class "ui bottom attached button", onClick Increment ]
                                [ i [ class "add icon", attribute "style" "margin:0px" ]
                                    []
                                ]
                            , div [ class "ui bottom attached button", onClick Decrement ]
                                [ i [ class "minus icon", attribute "style" "margin:0px" ]
                                    []
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }
