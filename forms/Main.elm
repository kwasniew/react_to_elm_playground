port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onSubmit, onInput, on)
import Html.Attributes exposing (placeholder, type_, value, style, alt, src, disabled, selected)
import Regex
import Process
import Task exposing (Task)
import Time
import Api.Core
import Api.Electives


type alias Flags =
    { people : List Person }


type alias Person =
    { name : String
    , email : String
    , department : String
    , course : String
    }


type alias Model =
    { people : List Person
    , name : String
    , nameError : Maybe String
    , email : String
    , emailError : Maybe String
    , department : String
    , courses : List String
    , courseLoading : Bool
    , course : String
    , isLoading : Bool
    , saveStatus : Status
    }


type Status
    = Ready
    | Saving
    | Success
    | Error


type Msg
    = Submit
    | CurrentName String
    | CurrentEmail String
    | SelectDepartment String
    | FetchCoursesSuccess (List String)
    | SelectCourse String
    | SavePeopleSuccess (List Person)
    | SavePeopleFailure String
    | FetchPeopleSuccess (List Person)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { people = []
      , name = ""
      , nameError = Nothing
      , email = ""
      , emailError = Nothing
      , department = ""
      , courses = []
      , courseLoading = False
      , course = ""
      , isLoading = True
      , saveStatus = Ready
      }
    , fetchPeople flags.people
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


withSelection : String -> String -> List (Attribute Msg)
withSelection val current =
    if val == current then
        [ value val, selected True ]
    else
        [ value val ]


departmentSelect : String -> Html Msg
departmentSelect department =
    select [ onInput SelectDepartment ]
        [ option (withSelection "" department) [ text "Which department?" ]
        , option (withSelection "core" department) [ text "NodeSchool: Core" ]
        , option (withSelection "electives" department) [ text "NodeSchool: Electives" ]
        ]


courseSelect : Model -> Html Msg
courseSelect model =
    if model.courseLoading then
        img [ alt "loading", src "/img/loading.gif" ] []
    else if (List.length model.courses) == 0 then
        span [] []
    else
        select [ onInput SelectCourse ]
            ((option (withSelection "" model.course) [ text "Which course?" ])
                :: (List.map
                        (\course -> option (withSelection course model.course) [ text course ])
                        model.courses
                   )
            )


isInvalid : Model -> Bool
isInvalid model =
    model.name == "" || model.department == "" || model.course == "" || (not (isValidEmail model.email))


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


submitButton : Model -> Html Msg
submitButton model =
    case model.saveStatus of
        Ready ->
            input [ type_ "submit", disabled (isInvalid model), value "Submit" ] []

        Saving ->
            input [ type_ "submit", disabled True, value "Saving..." ] []

        Success ->
            input [ type_ "submit", disabled True, value "Saved!" ] []

        Error ->
            input [ type_ "submit", disabled (isInvalid model), value "Save Failure - Retry?" ] []


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
                , submitButton model
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
                                        , field.department
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
            -- regex from rtfeldman/elm-validate. Looks like it does not cover 100% cases
            Regex.regex "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                |> Regex.caseInsensitive
    in
        Regex.contains validEmail



-- this is a slow request simulation


fetchCourses : String -> Cmd Msg
fetchCourses department =
    case department of
        "core" ->
            Process.sleep (1 * Time.second) |> Task.perform (\_ -> FetchCoursesSuccess Api.Core.courses)

        "electives" ->
            Process.sleep (1 * Time.second) |> Task.perform (\_ -> FetchCoursesSuccess Api.Electives.courses)

        _ ->
            Cmd.none



-- this is a slow request simulation


fetchPeople : List Person -> Cmd Msg
fetchPeople people =
    Process.sleep (1 * Time.second) |> Task.perform (\_ -> FetchPeopleSuccess people)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            let
                people =
                    List.append model.people [ Person model.name model.email model.department model.course ]
            in
                ( { model
                    | saveStatus = Saving
                  }
                , savePeople people
                )

        CurrentName txt ->
            ( { model
                | name = txt
                , nameError = validateName txt
                , saveStatus = Ready
              }
            , Cmd.none
            )

        CurrentEmail txt ->
            ( { model
                | email = txt
                , emailError = validateEmail txt
                , saveStatus = Ready
              }
            , Cmd.none
            )

        SelectDepartment department ->
            let
                courseLoading =
                    department /= ""

                courses =
                    if department == "" then
                        []
                    else
                        model.courses
            in
                ( { model
                    | department = department
                    , courses = courses
                    , course = ""
                    , courseLoading = courseLoading
                    , saveStatus = Ready
                  }
                , fetchCourses department
                )

        FetchCoursesSuccess courses ->
            ( { model
                | courses = courses
                , courseLoading = False
              }
            , Cmd.none
            )

        SelectCourse txt ->
            ( { model | course = txt }, Cmd.none )

        SavePeopleSuccess people ->
            ( { model
                | people = people
                , saveStatus = Success
              }
            , Cmd.none
            )

        SavePeopleFailure _ ->
            ( { model | saveStatus = Error }, Cmd.none )

        FetchPeopleSuccess people ->
            ( { model | isLoading = False, people = people }, Cmd.none )


port savePeople : List Person -> Cmd msg


port savePeopleSuccess : (List Person -> msg) -> Sub msg


port savePeopleFailure : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ savePeopleSuccess SavePeopleSuccess, savePeopleFailure SavePeopleFailure ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view, init = init, update = update, subscriptions = subscriptions }
