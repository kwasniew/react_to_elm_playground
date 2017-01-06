module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Navigation exposing (Location, newUrl)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Json


type alias Model =
    { location : Location
    }


type Msg
    = UrlChange Location
    | LinkTo String


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


onClickWithoutDefault : msg -> Attribute msg
onClickWithoutDefault msg =
    onWithOptions "click" { stopPropagation = False, preventDefault = True } (Json.succeed msg)


link : String -> List (Html Msg) -> Html Msg
link to children =
    a [ href to, onClickWithoutDefault (LinkTo to) ] children


match : Location -> String -> Html msg -> Html msg
match location path view =
    if (Debug.log "pathname" location.pathname) == path then
        view
    else
        text ""


view : Model -> Html Msg
view model =
    div [ class "ui text container" ]
        [ h2 [ class "ui dividing header" ]
            [ text "Which body of water?"
            ]
        , ul []
            [ li []
                [ link "/atlantic"
                    [ code []
                        [ text "/atlantic" ]
                    ]
                ]
            , li []
                [ link "/pacific"
                    [ code []
                        [ text "/pacific" ]
                    ]
                ]
            ]
        , hr [] []
        , match model.location "/atlantic" atlantic
        , match model.location "/pacific" pacific
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | location = location }, Cmd.none )

        LinkTo path ->
            ( model, newUrl path )


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
