module TopBar exposing (topBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Router exposing (link, to, onClickWithoutDefault, RouterMsg(..))


topBar : Html RouterMsg
topBar =
    div [ class "ui huge top attached fluid secondary menu" ]
        [ div [ class "item" ] []
        , div [ class "item" ]
            [ h1 [ class "ui green header", style [ ( "marginTop", "10px" ) ] ] [ text "Notify" ]
            ]
        , div [ class "right menu" ]
            -- TODO: try link abstraction
            [ a [ class "ui item", href "/logout", onClickWithoutDefault (LinkTo "/logout") ] [ text "Logout" ]
            ]
        ]
