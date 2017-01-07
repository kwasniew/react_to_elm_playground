module VerticalMenu exposing (verticalMenu)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


verticalMenu : Html Msg
verticalMenu =
    div [ class "ui secondary vertical menu" ]
        [ div [ class "header item" ]
            [ text "Albums"
            ]
        ]
