module Client exposing (..)

import Http exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Types exposing (..)


search : String -> Cmd Msg
search query =
    Http.send Fetched <| Http.get ("/api/food?q=" ++ query) foodsDecoder


foodsDecoder : Decoder (List Food)
foodsDecoder =
    (list foodDecoder)


foodDecoder : Decoder Food
foodDecoder =
    decode Food
        |> optional "description" string "no description"
        |> optional "kcal" float 0.0
        |> optional "protein_g" float 0.0
        |> optional "fat_g" float 0.0
        |> optional "carbohydrate_g" float 0.0
