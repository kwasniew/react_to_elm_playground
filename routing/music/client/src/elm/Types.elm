module Types exposing (..)

import Router exposing (RouterMsg)
import Http
import Navigation exposing (Location)


type alias Model =
    { fetched : Bool
    , albums : List Album
    , location : Location
    }


type alias Album =
    { id : String
    , name : String
    , imageUrl : String
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
    | UrlChange Location
