module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import TopBar exposing (topBar)
import Types exposing (..)
import AlbumsContainer exposing (albumsContainer)
import Client exposing (getAlbums)


-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = (\_ -> Sub.none) }



-- MODEL


albumIds : List String
albumIds =
    [ "23O4F21GDWiGd33tFN3ZgI"
    , "3AQgdwMNCiN7awXch5fAaG"
    , "1kmyirVya5fRxdjsPFDM05"
    , "6ymZBbRSmzAvoSGmwAFoxm"
    , "4Mw9Gcu1LT7JaipXdwrq1Q"
    ]


init : ( Model, Cmd Msg )
init =
    ( { fetched = False, albums = [] }
    , getAlbums albumIds "D6W69PRgCoDKgHZGJmRUNA"
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AlbumsFetched response ->
            case response of
                Ok albums ->
                    ( { model | albums = albums, fetched = True }, Cmd.none )

                Result.Err err ->
                    let
                        _ =
                            Debug.log "error" err
                    in
                        ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "ui grid" ]
        [ Html.map Router (topBar True)
        , div [ class "spacer row" ] []
        , div [ class "row" ] [ albumsContainer model.fetched model.albums ]
        ]
