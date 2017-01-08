module Login exposing (login)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


login : Bool -> Html Msg
login loginInProgress =
    div [ class "ui one column centered grid" ]
        [ div [ class "ten wide column" ]
            [ div [ class "ui raised very padded text container segment", style [ ( "textAlign", "center" ) ] ]
                [ h2 [ class "ui green header" ] [ text "Notify" ]
                , if loginInProgress then
                    div [ class "ui active centered inline loader" ] []
                  else
                    div [ class "ui large green submit button", onClick PerformLogin ] [ text "Login" ]
                ]
            ]
        ]
