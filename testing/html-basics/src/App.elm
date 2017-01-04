module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { items : List String
    , item : String
    }


type Msg
    = AddItem
    | ItemChange String


init : ( Model, Cmd Msg )
init =
    ( { items = []
      , item = ""
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    div [ class "ui text container", id "app" ]
        [ table [ class "ui selectable structured large table" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Items" ]
                    ]
                ]
            , tbody []
                (List.map
                    (\item ->
                        tr []
                            [ td []
                                [ text item ]
                            ]
                    )
                    model.items
                )
            , tfoot []
                [ tr []
                    [ th []
                        [ Html.form [ class "ui form", onSubmit AddItem ]
                            [ div [ class "field" ]
                                [ input
                                    [ class "prompt", type_ "text", placeholder "Add item...", value model.item, onInput ItemChange ]
                                    []
                                ]
                            , button
                                [ class "ui button", type_ "submit", disabled (model.item == "") ]
                                [ text "Add item" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ItemChange txt ->
            ( { model | item = txt }, Cmd.none )

        AddItem ->
            ( { model | items = List.append model.items [ model.item ], item = "" }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
