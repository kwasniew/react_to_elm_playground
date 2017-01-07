module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Navigation exposing (Location, newUrl)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Json
import Process
import Time
import Task exposing (Task)
import Regex


type alias Model =
    { location : Location
    , counter : Int
    }


type Msg
    = UrlChange Location
    | LinkTo String
    | CountDown


type alias MatchSpec msg =
    { pattern : String
    , render : Html msg
    , exactly : Bool
    }


defaultMatchSpec : MatchSpec msg
defaultMatchSpec =
    { pattern = "/"
    , render = text ""
    , exactly = False
    }


init : Location -> ( Model, Cmd Msg )
init location =
    ( { location = location, counter = 3 }, Cmd.none )


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


blackSea : Int -> Html msg
blackSea counter =
    div []
        [ h3 [] [ text "Black Sea" ]
        , p [] [ text "Nothing to sea [sic] here ..." ]
        , p [] [ text <| "Redirecting in " ++ toString counter ++ "..." ]
        ]


onClickWithoutDefault : msg -> Attribute msg
onClickWithoutDefault msg =
    onWithOptions "click" { stopPropagation = False, preventDefault = True } (Json.succeed msg)


link : String -> List (Html Msg) -> Html Msg
link to children =
    a [ href to, onClickWithoutDefault (LinkTo to) ] children


exactMatch : Location -> MatchSpec msg -> Bool
exactMatch checkLocation matchSpec =
    matchSpec.exactly && matchSpec.pattern == checkLocation.pathname


looseMatch : Location -> MatchSpec msg -> Bool
looseMatch checkLocation matchSpec =
    matchSpec.exactly == False && Regex.contains (Regex.regex ("^" ++ matchSpec.pattern)) checkLocation.pathname


isMatch : Location -> MatchSpec msg -> Bool
isMatch checkLocation matchSpec =
    exactMatch checkLocation matchSpec || looseMatch checkLocation matchSpec


match : Location -> MatchSpec msg -> Html msg
match checkLocation matchSpec =
    if isMatch checkLocation matchSpec then
        matchSpec.render
    else
        defaultMatchSpec.render


miss : Location -> List (MatchSpec msg) -> Html msg -> Html msg
miss checkLocation matchSpecs render =
    if List.any (\matchSpec -> isMatch checkLocation matchSpec) matchSpecs then
        defaultMatchSpec.render
    else
        render


view : Model -> Html Msg
view model =
    let
        matchLocation =
            match model.location

        matchSpecs =
            [ { defaultMatchSpec | pattern = "/atlantic", render = atlantic }
            , { defaultMatchSpec | pattern = "/pacific", render = pacific }
            , { defaultMatchSpec | pattern = "/black-sea", render = (blackSea model.counter) }
            , { exactly = True, pattern = "/", render = (h3 [] [ text "Welcome! Select a body of saline water above." ]) }
            ]

        matchLocationSpecs =
            List.map matchLocation matchSpecs
    in
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
                , li []
                    [ link "/black-sea"
                        [ code []
                            [ text "/black-sea" ]
                        ]
                    ]
                ]
            , hr [] []
            , div [] matchLocationSpecs
            , miss model.location
                matchSpecs
                (div [ class "ui inverted red segment" ]
                    [ h3 []
                        [ text "Error! No matches for"
                        , code [] [ text model.location.pathname ]
                        ]
                    ]
                )
            ]


countDown : Task Never a -> Cmd Msg
countDown =
    Task.perform (\_ -> CountDown)


inOneSecond : (Task x () -> a) -> a
inOneSecond do =
    Process.sleep (1 * Time.second) |> do


redirect : String -> Task Never a -> Cmd Msg
redirect path =
    Task.perform (\_ -> LinkTo path)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                shouldTriggerCounter =
                    location.pathname == "/black-sea"
            in
                ( { model
                    | location = location
                    , counter = 3
                  }
                , if shouldTriggerCounter then
                    inOneSecond countDown
                  else
                    Cmd.none
                )

        LinkTo path ->
            ( model, newUrl path )

        CountDown ->
            let
                counter =
                    model.counter - 1

                shouldRedirect =
                    counter == 1
            in
                ( { model | counter = counter }
                , if shouldRedirect then
                    inOneSecond (redirect "/")
                  else
                    inOneSecond countDown
                )


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
