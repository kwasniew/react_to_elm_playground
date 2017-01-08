port module Client exposing (getAlbums, setToken, removeToken, login)

import Http exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Types exposing (..)


getAlbums : List String -> String -> Cmd Msg
getAlbums albumIds token =
    Http.send AlbumsFetched <| Http.get ("/api/albums?ids=" ++ (String.join "," albumIds) ++ "&token=" ++ token) albumsDecoder


login : Cmd Msg
login =
    Http.send TokenReceived <| Http.post "/api/login" Http.emptyBody tokenDecoder


tokenDecoder : Decoder String
tokenDecoder =
    field "token" string


albumsDecoder : Decoder (List Album)
albumsDecoder =
    (list albumDecoder)


albumDecoder : Decoder Album
albumDecoder =
    decode Album
        |> optional "id" string ""
        |> optional "name" string ""
        |> optional "imageUrl" string ""
        |> optional "year" string ""
        |> optional "artist" artistDecoder { name = "" }
        |> optional "tracks" (list trackDecoder) []


artistDecoder : Decoder Artist
artistDecoder =
    decode Artist
        |> optional "name" string "unknown"


trackDecoder : Decoder Track
trackDecoder =
    decode Track
        |> optional "id" string ""
        |> optional "trackNumber" int 0
        |> optional "name" string ""
        |> optional "durationMs" int 0


port setToken : String -> Cmd msg


port removeToken : () -> Cmd msg



-- port getToken : (String -> msg) -> Sub msg
