module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput, on)
import Html.Attributes exposing (placeholder, type_, value, style, alt, src, disabled)
import Regex
import Process
import Task
import Time
import Api.Core
import Api.Electives


type alias Person =
    { name : String
    , email : String
    , department : Department
    , course : String
    }


type alias Model =
    { people : List Person
    , name : String
    , nameError : Maybe String
    , email : String
    , emailError : Maybe String
    , department : Maybe Department
    , courses : List String
    , courseLoading : Bool
    , course : String
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
    | Fetched (List String)
    | SetCourse String


init : ( Model, Cmd Msg )
init =
    ( { people = []
      , name = ""
      , nameError = Nothing
      , email = ""
      , emailError = Nothing
      , department = Nothing
      , courses = []
      , courseLoading = False
      , course = ""
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


departmentSelect : Maybe Department -> Html Msg
departmentSelect department =
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


courseSelect : Model -> Html Msg
courseSelect model =
    if model.courseLoading then
        img [ alt "loading", src "/img/loading.gif" ] []
    else if (List.length model.courses) == 0 then
        span [] []
    else
        select [ value model.course, onInput SetCourse ]
            ((option [ value "" ] [ text "Which course?" ])
                :: (List.map
                        (\course -> option [ value course ] [ text course ])
                        model.courses
                   )
            )


isInvalid : Model -> Bool
isInvalid model =
    model.name == "" || model.department == Nothing || model.course == "" || (not (isValidEmail model.email))


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
                , div []
                    [ departmentSelect model.department
                    , br [] []
                    , courseSelect model
                    ]
                , br [] []
                , input [ type_ "submit", disabled (isInvalid model) ] []
                ]
            , div []
                [ h3 [] [ text "People" ]
                , ul []
                    (List.map
                        (\field ->
                            li []
                                [ text
                                    (String.join " - "
                                        [ field.name
                                        , field.email
                                        , (String.toLower (toString field.department))
                                        , field.course
                                        ]
                                    )
                                ]
                        )
                        model.people
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


fetchCourses : Maybe Department -> Cmd Msg
fetchCourses department =
    case department of
        Just Core ->
            Process.sleep (1 * Time.second) |> Task.perform (\_ -> Fetched Api.Core.courses)

        Just Electives ->
            Process.sleep (1 * Time.second) |> Task.perform (\_ -> Fetched Api.Electives.courses)

        Nothing ->
            Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            case model.department of
                Just department ->
                    ( { model
                        | people = List.append model.people [ Person model.name model.email department model.course ]
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
            let
                department =
                    stringToDepartment txt

                courseLoading =
                    department /= Nothing

                courses =
                    if department == Nothing then
                        []
                    else
                        model.courses
            in
                ( { model | department = department, courses = courses, course = "", courseLoading = courseLoading }
                , fetchCourses department
                )

        Fetched courses ->
            ( { model | courses = courses, courseLoading = False }, Cmd.none )

        SetCourse txt ->
            ( { model | course = txt }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
