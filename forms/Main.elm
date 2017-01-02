module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (placeholder, type_, value)


type alias Field =
    { name : String
    , email : String
    }


type alias Model =
    { fields : List Field
    , name : String
    , email : String
    }


type Msg
    = Submit
    | CurrentName String
    | CurrentEmail String


init : ( Model, Cmd Msg )
init =
    ( { fields = [], name = "", email = "" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Sign Up Sheet" ]
        , form [ onSubmit Submit ]
            [ input [ placeholder "Name", onInput CurrentName, value model.name ] []
            , input [ placeholder "Email", onInput CurrentEmail, value model.email ] []
            , input [ type_ "submit" ] []
            ]
        , div []
            [ h3 [] [ text "names" ]
            , ul []
                (List.map
                    (\field ->
                        li []
                            [ text (field.name ++ " (" ++ field.email ++ ")")
                            ]
                    )
                    model.fields
                )
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            ( { model
                | fields = List.append model.fields [ Field model.name model.email ]
                , name = ""
              }
            , Cmd.none
            )

        CurrentName txt ->
            ( { model | name = txt }, Cmd.none )

        CurrentEmail txt ->
            ( { model | email = txt }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
