module Login exposing (login)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


login : Html Msg
login =
    div [ class "ui one column centered grid" ]
        [ div [ class "ten wide column" ]
            [ div [ class "ui raised very padded text container segment", style [ ( "textAlign", "center" ) ] ]
                [ h2 [ class "ui green header" ] [ text "Notify" ]
                ]
            ]
        ]
