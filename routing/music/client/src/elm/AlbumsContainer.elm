module AlbumsContainer exposing (albumsContainer)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Album exposing (album)
import VerticalMenu exposing (verticalMenu)
import Router exposing (matchWithData)
import UrlParser exposing (s, string, top, (</>))


albumsView : List Album -> String -> String -> Html Msg
albumsView albums selectedAlbumId pathname =
    div []
        (albums |> List.filter (\a -> a.id == selectedAlbumId) |> List.map (\a -> album a pathname))


albumsContainer : Model -> String -> Html Msg
albumsContainer model pathname =
    if not model.fetched then
        div [ class "ui active centered inline loader" ] []
    else
        div [ class "ui two column divided grid" ]
            [ div [ class "ui six wide column", style [ ( "maxWidth", "250" ) ] ]
                [ verticalMenu model.albums pathname ]
            , div [ class "ui ten wide column" ]
                [ (matchWithData
                    (UrlParser.s "albums" </> string)
                    model.location
                    (\id ->
                        albumsView model.albums id (pathname ++ "/")
                    )
                  )
                ]
            ]
