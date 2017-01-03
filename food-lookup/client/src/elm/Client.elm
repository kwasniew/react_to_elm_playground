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
        |> required "description" string
        |> required "kcal" float
        |> required "protein_g" float
        |> required "fat_g" float
        |> required "carbohydrate_g" float
