module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (placeholder, type_, value)


type alias Model =
    { names : List String
    , name : String
    }


type Msg
    = Submit
    | CurrentName String


init : ( Model, Cmd Msg )
init =
    ( { names = [], name = "" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Sign Up Sheet" ]
        , form [ onSubmit Submit ]
            [ input [ placeholder "Name", onInput CurrentName, value model.name ] []
            , input [ type_ "submit" ] []
            ]
        , div []
            [ h3 [] [ text "names" ]
            , ul []
                (List.map (\name -> li [] [ text name ]) model.names)
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            ( { model
                | names = List.append model.names [ model.name ]
                , name = ""
              }
            , Cmd.none
            )

        CurrentName name ->
            ( { model | name = name }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
