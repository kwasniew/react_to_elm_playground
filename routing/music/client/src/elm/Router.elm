module Router exposing (link, to, onClickWithoutDefault, RouterMsg(..))

import Html exposing (a, Attribute, Html)
import Html.Attributes exposing (href, attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json


onClickWithoutDefault : msg -> Attribute msg
onClickWithoutDefault msg =
    onWithOptions "click" { stopPropagation = False, preventDefault = True } (Json.succeed msg)


type alias LinkConfig msg =
    { to : String
    , msg : String -> msg
    , className : String
    }


type RouterMsg
    = LinkTo String


defaultLinkConfig : msg -> LinkConfig msg
defaultLinkConfig msg =
    { to = ""
    , msg = (\x -> msg)
    , className = ""
    }


to : String -> Attribute msg
to location =
    href location


link : List (Attribute msg) -> List (Html msg) -> Html msg
link attributes children =
    -- a [ href linkConfig.to, onClickWithoutDefault (linkConfig.msg linkConfig.to) ] children
    a
        (List.map
            (\a ->
                let
                    x =
                        Debug.log "attr" a
                in
                    a
            )
            attributes
        )
        children
