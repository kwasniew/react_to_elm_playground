module CustomHttp exposing (..)

import Http exposing (..)
import Json.Decode exposing (..)


put : String -> Body -> Decoder a -> Request a
put url body decoder =
    request
        { method = "PUT"
        , headers = []
        , url = url
        , body = body
        , expect = expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


delete : String -> Body -> Decoder a -> Request a
delete url body decoder =
    request
        { method = "DELETE"
        , headers = []
        , url = url
        , body = body
        , expect = expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }
