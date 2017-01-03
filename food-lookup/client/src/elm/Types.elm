module Types exposing (..)

import Http


type alias Food =
    { description : String
    , kcal : Float
    , protein_g : Float
    , fat_g : Float
    , carbohydrate_g : Float
    }


type alias Model =
    { searchValue : String
    , foods : List Food
    , selectedFoods : List Food
    }


type Msg
    = Search String
    | Remove
    | Fetched (Result Http.Error (List Food))
