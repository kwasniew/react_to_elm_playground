module Router exposing (onClickWithoutDefault, match, RouterMsg(..))

import Html exposing (a, Attribute, Html, text)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json
import Navigation exposing (Location, newUrl)
import UrlParser exposing ((</>), s, int, string, parsePath, top)


onClickWithoutDefault : msg -> Attribute msg
onClickWithoutDefault msg =
    onWithOptions "click" { stopPropagation = False, preventDefault = True } (Json.succeed msg)


type RouterMsg
    = LinkTo String


type alias Match msg =
    { pattern : String
    , render : Html msg
    }


pathMatch : Location -> Match msg -> Bool
pathMatch checkLocation matchSpec =
    parsePath (UrlParser.string) checkLocation == Just (String.dropLeft 1 matchSpec.pattern)


match : List (Match msg) -> Location -> String -> Html msg
match matches location pattern =
    let
        maybeMatch =
            List.head <| List.filter (\route -> pathMatch location route) matches
    in
        case maybeMatch of
            Just match ->
                match.render

            Nothing ->
                text ""
