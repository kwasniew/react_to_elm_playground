module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput, on)
import Html.Attributes exposing (placeholder, type_, value, style, alt, src, disabled)
import Regex


type alias Field =
    { name : String
    , email : String
    , department : Department
    }


type alias Model =
    { fields : List Field
    , name : String
    , nameError : Maybe String
    , email : String
    , emailError : Maybe String
    , department : Maybe Department
    , isLoading : Bool
    }


type Department
    = Core
    | Electives


type Msg
    = Submit
    | CurrentName String
    | CurrentEmail String
    | SetDepartment String


init : ( Model, Cmd Msg )
init =
    ( { fields = []
      , name = ""
      , nameError = Nothing
      , email = ""
      , emailError = Nothing
      , department = Nothing
      , isLoading = False
      }
    , Cmd.none
    )


errorField : Maybe String -> Html Msg
errorField error =
    let
        txt =
            case error of
                Just error ->
                    error

                Nothing ->
                    ""
    in
        span [ style [ ( "color", "red" ) ] ] [ text txt ]


depertmentSelect : Maybe Department -> Html Msg
depertmentSelect department =
    let
        val =
            case department of
                Just value ->
                    String.toLower (toString value)

                Nothing ->
                    ""
    in
        select [ value val, onInput SetDepartment ]
            [ option [ value "" ] [ text "Which department?" ]
            , option [ value "core" ] [ text "NodeSchool: Core" ]
            , option [ value "electives" ] [ text "NodeSchool: Electives" ]
            ]


courseSelect : Maybe Department -> Html Msg
courseSelect department =
    div [] [ depertmentSelect department ]


isInvalid : Model -> Bool
isInvalid model =
    if model.name == "" then
        True
    else if model.department == Nothing then
        True
    else if not (isValidEmail model.email) then
        True
    else
        False


validateEmail : String -> Maybe String
validateEmail email =
    if not (isValidEmail email) then
        Just "Invalid Email"
    else
        Nothing


validateName : String -> Maybe String
validateName name =
    if name == "" then
        Just "Name Required"
    else
        Nothing


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
                    , errorField model.nameError
                    ]
                , br [] []
                , div []
                    [ input [ placeholder "Email", onInput CurrentEmail, value model.email ] []
                    , errorField model.emailError
                    ]
                , br [] []
                , courseSelect model.department
                , br [] []
                , input [ type_ "submit", disabled (isInvalid model) ] []
                ]
            , div []
                [ h3 [] [ text "People" ]
                , ul []
                    (List.map
                        (\field ->
                            li []
                                [ text (String.join " - " [ field.name, field.email, (String.toLower (toString field.department)) ])
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


stringToDepartment : String -> Maybe Department
stringToDepartment department =
    case department of
        "core" ->
            Just Core

        "electives" ->
            Just Electives

        _ ->
            Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            case model.department of
                Just department ->
                    ( { model
                        | fields = List.append model.fields [ Field model.name model.email department ]
                        , name = ""
                        , email = ""
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        CurrentName txt ->
            ( { model | name = txt, nameError = validateName txt }, Cmd.none )

        CurrentEmail txt ->
            ( { model | email = txt, emailError = validateEmail txt }, Cmd.none )

        SetDepartment txt ->
            ( { model | department = stringToDepartment txt }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
