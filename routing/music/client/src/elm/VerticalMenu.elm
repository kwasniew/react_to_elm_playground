module VerticalMenu exposing (verticalMenu)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Router exposing (onClickWithoutDefault)


verticalMenu : List Album -> String -> Html Msg
verticalMenu albums pathname =
    div [ class "ui secondary vertical menu" ]
        (div [ class "header item" ]
            [ text "Albums"
            ]
            :: (List.map
                    (\album ->
                        let
                            link =
                                album.id
                        in
                            a [ class "item", href link, onClickWithoutDefault (LinkTo link) ] [ text album.name ]
                    )
                    albums
               )
        )
