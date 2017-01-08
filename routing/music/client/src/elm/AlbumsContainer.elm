module AlbumsContainer exposing (albumsContainer)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Album exposing (album)
import VerticalMenu exposing (verticalMenu)
import Router exposing (matchWithData)
import UrlParser exposing (s, string, top, (</>))


albumsView : List Album -> String -> Html Msg
albumsView albums selectedAlbumId =
    div []
        (albums |> List.filter (\a -> a.id == selectedAlbumId) |> List.map (\a -> album a))


albumsContainer : Model -> Html Msg
albumsContainer model =
    if not model.fetched then
        div [ class "ui active centered inline loader" ] []
    else
        div [ class "ui two column divided grid" ]
            [ div [ class "ui six wide column", style [ ( "maxWidth", "250" ) ] ]
                [ verticalMenu model.albums ]
            , div [ class "ui ten wide column" ]
                [ (matchWithData
                    (UrlParser.s "albums" </> string)
                    model.location
                    (\id ->
                        albumsView model.albums id
                    )
                  )
                ]
            ]
