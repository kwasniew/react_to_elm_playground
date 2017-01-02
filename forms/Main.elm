module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (placeholder, type_, value, style, alt, src)
import Regex


type alias Field =
    { name : String
    , email : String
    , department : String
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
    , department : String
    , isLoading : Bool
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
      , department = ""
      , isLoading = False
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


depertmentSelect : String -> Html Msg
depertmentSelect department =
    select [ value department ]
        [ option [ value "" ] [ text "Which department?" ]
        , option [ value "core" ] [ text "NodeSchool: Core" ]
        , option [ value "electives" ] [ text "NodeSchool: Electives" ]
        ]


courseSelect : String -> Html Msg
courseSelect department =
    div [] [ depertmentSelect department ]


view : Model -> Html Msg
view model =
    if model.isLoading then
        img [ alt "loading", src "/img/loading.gif" ] []
    else
        div []
            [ h1 []
                [ text "Sign Up Sheet" ]
            , form [ onSubmit Submit ]
                [ div []
                    [ input [ placeholder "Name", onInput CurrentName, value model.name ] []
                    , errorField model.fieldErrors .name
                    ]
                , br [] []
                , div []
                    [ input [ placeholder "Email", onInput CurrentEmail, value model.email ] []
                    , errorField model.fieldErrors .email
                    ]
                , br [] []
                , courseSelect model.department
                , br [] []
                , input [ type_ "submit" ] []
                ]
            , div []
                [ h3 [] [ text "People" ]
                , ul []
                    (List.map
                        (\field ->
                            li []
                                [ text (String.join " - " [ field.name, field.email, field.department ])
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
                            | fields = List.append model.fields [ Field model.name model.email model.department ]
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
