module TopBar exposing (topBar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Router exposing (link, to, onClickWithoutDefault, RouterMsg(..))


topBar : Bool -> Html RouterMsg
topBar isLoggedIn =
    div [ class "ui huge top attached fluid secondary menu" ]
        [ div [ class "item" ] []
        , div [ class "item" ]
            [ h1 [ class "ui green header", style [ ( "marginTop", "10px" ) ] ] [ text "Notify" ]
            ]
        , div [ class "right menu" ]
            -- TODO: try link abstraction
            [ if isLoggedIn then
                a [ class "ui item", href "/logout", onClickWithoutDefault (LinkTo "/logout") ] [ text "Logout" ]
              else
                a [ class "ui item", href "/login", onClickWithoutDefault (LinkTo "/login") ] [ text "Login" ]
            ]
        ]
