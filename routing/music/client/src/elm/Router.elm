module Router exposing (onClickWithoutDefault, match, matchWithData, RouterMsg(..))

import Html exposing (a, Attribute, Html, text)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json
import Navigation exposing (Location, newUrl)
import UrlParser exposing ((</>), s, int, string, parsePath, top, Parser)


onClickWithoutDefault : msg -> Attribute msg
onClickWithoutDefault msg =
    onWithOptions "click" { stopPropagation = False, preventDefault = True } (Json.succeed msg)


type RouterMsg
    = LinkTo String


type alias Match a msg =
    { pattern : Parser (a -> a) a
    , render : Html msg
    }


match : Parser (a -> a) a -> Location -> Html msg -> Html msg
match parser checkLocation view =
    case parsePath parser checkLocation of
        Just a ->
            view

        Nothing ->
            text ""


matchWithData : Parser (a -> a) a -> Location -> (a -> Html msg) -> Html msg
matchWithData parser checkLocation view =
    case parsePath parser checkLocation of
        Just val ->
            view val

        Nothing ->
            text ""
