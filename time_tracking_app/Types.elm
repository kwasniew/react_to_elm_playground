module Types exposing (..)

import Uuid exposing (Uuid)
import Time exposing (Time)
import Random.Pcg exposing (Seed)
import Http


type alias Model =
    { timers : List Timer
    , currentTime : Time
    , formOpen : Bool
    , title : String
    , project : String
    , currentSeed : Seed
    , currentUuid : Maybe Uuid
    }


type alias Flags =
    { now : Time, seed : Int }


type alias Timer =
    { title : String
    , project : String
    , prevTitle : String
    , prevProject : String
    , elapsed : Time
    , runningSince : Maybe Time
    , editFormOpen : Bool
    , id : Uuid
    }


type alias TimerForm =
    { title : String
    , project : String
    , submitText : String
    , id : Maybe Uuid
    }


type Msg
    = Tick Time
    | OpenForm
    | Submit (Maybe Uuid)
    | Close (Maybe Uuid)
    | Title (Maybe Uuid) String
    | Project (Maybe Uuid) String
    | Edit Uuid
    | Delete Uuid
    | Start Uuid
    | Stop Uuid
    | FetchAll Time
    | Fetched (Result Http.Error (List Timer))
    | Posted (Result Http.Error String)
