module AlbumsContainer exposing (albumsContainer)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Album exposing (album)
import VerticalMenu exposing (verticalMenu)


albumsContainer : Bool -> List Album -> Html Msg
albumsContainer fetched albums =
    if not fetched then
        div [ class "ui active centered inline loader" ] []
    else
        div [ class "ui two column divided grid" ]
            [ div [ class "ui six wide column", style [ ( "maxWidth", "250" ) ] ]
                [ Html.map Router <| verticalMenu albums ]
            , div [ class "ui ten wide column" ] (List.map (\alb -> div [ class "row" ] [ album alb ]) albums)
            ]
