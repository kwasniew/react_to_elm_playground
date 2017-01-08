module VerticalMenu exposing (verticalMenu)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Router exposing (onClickWithoutDefault)


verticalMenu : List Album -> Html Msg
verticalMenu albums =
    div [ class "ui secondary vertical menu" ]
        (div [ class "header item" ]
            [ text "Albums"
            ]
            :: (List.map
                    (\album ->
                        let
                            link =
                                "/albums/" ++ album.id
                        in
                            a [ class "item", href link, onClickWithoutDefault (LinkTo link) ] [ text album.name ]
                    )
                    albums
               )
        )
