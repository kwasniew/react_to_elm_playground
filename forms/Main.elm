module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (placeholder, type_, value, style)
import Regex


type alias Field =
    { name : String
    , email : String
    }


type alias Errors =
    { name : Maybe String
    , email : Maybe String
    }


type alias Model =
    { fields : List Field
    , fieldErrors : Maybe Errors
    , name : String
    , email : String
    }


type Msg
    = Submit
    | CurrentName String
    | CurrentEmail String


init : ( Model, Cmd Msg )
init =
    ( { fields = []
      , fieldErrors = Nothing
      , name = ""
      , email = ""
      }
    , Cmd.none
    )


errorField : Maybe Errors -> (Errors -> Maybe String) -> Html Msg
errorField errors fieldFn =
    let
        txt =
            case errors of
                Just errors ->
                    Maybe.withDefault "" (fieldFn errors)

                Nothing ->
                    ""
    in
        span [ style [ ( "color", "red" ) ] ] [ text txt ]


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Sign Up Sheet" ]
        , form [ onSubmit Submit ]
            [ input [ placeholder "Name", onInput CurrentName, value model.name ] []
            , errorField model.fieldErrors .name
            , br [] []
            , input [ placeholder "Email", onInput CurrentEmail, value model.email ] []
            , errorField model.fieldErrors .email
            , br [] []
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


isValidEmail : String -> Bool
isValidEmail =
    let
        validEmail =
            Regex.regex "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                |> Regex.caseInsensitive
    in
        Regex.contains validEmail


validationErrors : Model -> Maybe Errors
validationErrors model =
    let
        nameError =
            if model.name == "" then
                Just "Name Required"
            else
                Nothing

        emailError =
            (if model.email == "" then
                Just "Email Required"
             else if not (isValidEmail model.email) then
                Just "Invalid Email"
             else
                Nothing
            )
    in
        case ( nameError, emailError ) of
            ( Nothing, Nothing ) ->
                Nothing

            ( name, email ) ->
                Just (Errors name email)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            let
                errors =
                    validationErrors model
            in
                case errors of
                    Nothing ->
                        ( { model
                            | fields = List.append model.fields [ Field model.name model.email ]
                            , name = ""
                            , email = ""
                            , fieldErrors = Nothing
                          }
                        , Cmd.none
                        )

                    Just _ ->
                        ( { model | fieldErrors = errors }, Cmd.none )

        CurrentName txt ->
            ( { model | name = txt }, Cmd.none )

        CurrentEmail txt ->
            ( { model | email = txt }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
