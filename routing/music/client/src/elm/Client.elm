module Client exposing (getAlbums)

import Http exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Types exposing (..)


getAlbums : List String -> String -> Cmd Msg
getAlbums albumIds token =
    Http.send AlbumsFetched <| Http.get ("/api/albums?ids=" ++ (String.join "," albumIds) ++ "&token=" ++ token) albumsDecoder


albumsDecoder : Decoder (List Album)
albumsDecoder =
    (list albumDecoder)


albumDecoder : Decoder Album
albumDecoder =
    decode Album
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
