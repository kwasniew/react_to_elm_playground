module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Navigation exposing (Location)


type alias Model =
    { location : Location
    }


type Msg
    = UrlChange Location


init : Location -> ( Model, Cmd Msg )
init location =
    ( { location = location }, Cmd.none )


atlantic : Html msg
atlantic =
    div []
        [ h3 [] [ text "Atlantic Ocean" ]
        , p [] [ text "The Atlantic Ocean covers approximately 1/5th of the surface of the earth. " ]
        ]


pacific : Html msg
pacific =
    div []
        [ h3 [] [ text "Pacific Ocean" ]
        , p [] [ text "Ferdinand Magellan, a Portuguese explorer, named the ocean 'mar pacifico' in 1521, which means peaceful sea. " ]
        ]


view : Model -> Html Msg
view model =
    div [ class "ui text container" ]
        [ h2 [ class "ui dividing header" ]
            [ text "Which body of water?"
            ]
        , ul []
            [ li []
                [ a [ href "/atlantic" ]
                    [ code []
                        [ text "/atlantic" ]
                    ]
                ]
            , li []
                [ a [ href "/pacific" ]
                    [ code []
                        [ text "/pacific" ]
                    ]
                ]
            ]
        , hr [] []
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
