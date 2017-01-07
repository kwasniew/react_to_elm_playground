module Types exposing (..)

import Router exposing (RouterMsg)
import Http


type alias Model =
    { fetched : Bool
    , albums : List Album
    }


type alias Album =
    { imageUrl : String
    , year : String
    , artist : Artist
    , tracks : List Track
    }


type alias Artist =
    { name : String
    }


type alias Track =
    { id : String
    , trackNumber : Int
    , name : String
    , durationMs : Int
    }


type Msg
    = Router RouterMsg
    | AlbumsFetched (Result Http.Error (List Album))
