module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import TopBar exposing (topBar)
import Types exposing (..)
import AlbumsContainer exposing (albumsContainer)
import Client exposing (getAlbums)
import Router exposing (match)
import Navigation exposing (Location, newUrl)
import UrlParser exposing (s, string, (</>))
import Login exposing (login)


-- APP


main : Program Never Model Msg
main =
    Navigation.program UrlChange { init = init, view = view, update = update, subscriptions = (\_ -> Sub.none) }



-- MODEL


albumIds : List String
albumIds =
    [ "23O4F21GDWiGd33tFN3ZgI"
    , "3AQgdwMNCiN7awXch5fAaG"
    , "1kmyirVya5fRxdjsPFDM05"
    , "6ymZBbRSmzAvoSGmwAFoxm"
    , "4Mw9Gcu1LT7JaipXdwrq1Q"
    ]


init : Location -> ( Model, Cmd Msg )
init location =
    ( { fetched = False
      , albums = []
      , location = location
      , loginInProgress = False
      }
    , Cmd.batch [ getAlbums albumIds "D6W69PRgCoDKgHZGJmRUNA", redirect "/" (basePath ++ "/") location ]
    )



-- UPDATE


redirect : String -> String -> Location -> Cmd Msg
redirect from to location =
    if location.pathname == from then
        newUrl to
    else
        Cmd.none


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

        UrlChange location ->
            ( { model | location = location }, redirect "/" (basePath ++ "/") location )

        LinkTo url ->
            ( model, newUrl url )

        PerformLogin ->
            ( { model | loginInProgress = True }, Cmd.none )

        TokenReceived result ->
            ( model, Cmd.none )



-- VIEW


basePathSegment : String
basePathSegment =
    "albums"


basePath : String
basePath =
    "/" ++ basePathSegment


view : Model -> Html Msg
view model =
    div [ class "ui grid" ]
        [ topBar True
        , div [ class "spacer row" ] []
        , div [ class "row" ]
            [ match
                (UrlParser.s basePathSegment </> string)
                model.location
                (albumsContainer model basePath)
            , match
                (UrlParser.s "login")
                model.location
                (login model.loginInProgress)
            ]
        ]
