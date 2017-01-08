module Types exposing (..)

import Http
import Navigation exposing (Location)


type alias Model =
    { fetched : Bool
    , albums : List Album
    , location : Location
    , loginInProgress : Bool
    , token : Maybe String
    , targetPath : String
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
    = LinkTo String
    | AlbumsFetched (Result Http.Error (List Album))
    | UrlChange Location
    | PerformLogin
    | TokenReceived (Result Http.Error String)
