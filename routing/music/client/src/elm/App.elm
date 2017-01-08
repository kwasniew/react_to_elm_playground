module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import TopBar exposing (topBar)
import Types exposing (..)
import AlbumsContainer exposing (albumsContainer)
import Client exposing (getAlbums)
import Router exposing (match, redirect)
import Navigation exposing (Location, newUrl)
import UrlParser exposing (s, string, (</>), Parser)
import Login exposing (login)
import Http


-- APP


main : Program Never Model Msg
main =
    Navigation.program
        UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }



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
      , token = Nothing
      }
    , Cmd.batch
        [ redirectToBasePath location
        , redirectUnauthorizedAccess Nothing location
        ]
    )



-- UPDATE


error : Model -> Http.Error -> ( Model, Cmd Msg )
error model err =
    let
        _ =
            Debug.log "error" err
    in
        ( model, Cmd.none )


redirectToBasePath : Location -> Cmd msg
redirectToBasePath location =
    redirect "/" (basePath ++ "/") location


isUnauthorizedAccess : Maybe a -> Location -> Bool
isUnauthorizedAccess token location =
    token == Nothing && Router.isMatch albumsParser location


redirectUnauthorizedAccess : Maybe a -> Location -> Cmd msg
redirectUnauthorizedAccess token location =
    if isUnauthorizedAccess token location then
        newUrl "/login"
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
                    error model err

        UrlChange location ->
            if location.pathname == "/logout" then
                ( { model | token = Nothing }
                , Cmd.batch [ newUrl "/login", Client.removeToken () ]
                )
            else
                ( { model | location = location }
                , Cmd.batch
                    [ redirectToBasePath location
                    , redirectUnauthorizedAccess model.token location
                    ]
                )

        LinkTo url ->
            ( model, newUrl url )

        PerformLogin ->
            ( { model | loginInProgress = True }, Client.login )

        TokenReceived response ->
            case response of
                Ok token ->
                    ( { model | token = Just token, loginInProgress = False }
                    , Cmd.batch
                        [ getAlbums albumIds token
                        , Client.setToken token
                        , newUrl (basePath ++ "/")
                        ]
                    )

                Result.Err err ->
                    error model err



-- VIEW


basePathSegment : String
basePathSegment =
    "albums"


basePath : String
basePath =
    "/" ++ basePathSegment


albumsParser : Parser (String -> a) a
albumsParser =
    UrlParser.s basePathSegment </> string


view : Model -> Html Msg
view model =
    div [ class "ui grid" ]
        [ topBar (model.token /= Nothing)
        , div [ class "spacer row" ] []
        , div [ class "row" ]
            [ match
                albumsParser
                model.location
                (albumsContainer model basePath)
            , match
                (UrlParser.s "login")
                model.location
                (login model.loginInProgress)
            ]
        ]
