module Album exposing (album)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers exposing (durationToHuman)
import Router exposing (onClickWithoutDefault)


album : Album -> String -> Html Msg
album alb pathname =
    div [ class "Album" ]
        [ div [ class "row" ]
            [ div [ class "ui middle aligned three column grid" ]
                [ div [ class "six wide column", style [ ( "minWidth", "212px" ) ] ]
                    [ img [ src alb.imageUrl, style [ ( "width", "212px" ) ], alt "album" ] []
                    ]
                , div [ class "one wide column" ] []
                , div [ class "six wide column" ]
                    [ p []
                        [ text <|
                            "By "
                                ++ alb.artist.name
                                ++ " - "
                                ++ (toString alb.year)
                                ++ " - "
                                ++ (toString (List.length alb.tracks))
                                ++ " songs"
                        ]
                    , a [ class "ui left floated large button", href pathname, onClickWithoutDefault (LinkTo pathname) ] [ text "Close" ]
                    ]
                ]
            ]
        , div [ class "spacer row" ] []
        , div [ class "row" ]
            [ table [ class "ui very basic single line unstackable selectable table" ]
                [ thead []
                    [ tr []
                        [ th [] [ text "#" ]
                        , th [] [ text "Song" ]
                        , th []
                            [ i [ class "icon clock" ] []
                            ]
                        ]
                    ]
                , tbody []
                    (List.map
                        (\track ->
                            tr []
                                [ td [] [ text (toString track.trackNumber) ]
                                , td [] [ text track.name ]
                                , td [] [ text (durationToHuman track.durationMs) ]
                                ]
                        )
                        alb.tracks
                    )
                ]
            ]
        ]
