module VerticalMenu exposing (verticalMenu)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Router exposing (onClickWithoutDefault)


verticalMenu : Model -> String -> Html Msg
verticalMenu model pathname =
    div [ class "ui secondary vertical menu" ]
        (div [ class "header item" ]
            [ text "Albums"
            ]
            :: (List.map
                    (\album ->
                        let
                            link =
                                String.join "/" [ pathname, album.id ]

                            className =
                                if String.contains album.id model.location.pathname then
                                    "active item"
                                else
                                    "item"
                        in
                            a [ class className, href link, onClickWithoutDefault (LinkTo link) ] [ text album.name ]
                    )
                    model.albums
               )
        )
