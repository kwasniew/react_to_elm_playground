module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers exposing (renderElapsedString)
import Time exposing (Time, second)


type alias Model =
    { timers : List Timer
    , currentTime : Time
    }


type alias Flags =
    { now : Time }


type alias Timer =
    { title : String
    , project : String
    , elapsed : Time
    , runningSince : Maybe Time
    , editFormOpen : Bool
    }


type alias TimerForm =
    { title : String
    , project : String
    , submitText : String
    }


type Msg
    = Tick Time


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { timers =
            [ { title = "Learn Elm", project = "Web Domination", elapsed = 8986300, runningSince = Nothing, editFormOpen = False }
            , { title = "Learn extreme ironing", project = "World Domination", elapsed = 3890985, runningSince = Nothing, editFormOpen = True }
            ]
      , currentTime = flags.now
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    timersDashboard model


timersDashboard : Model -> Html Msg
timersDashboard model =
    div [ class "ui three column centered grid" ]
        [ div [ class "column" ]
            [ editableTimerList model.timers model.currentTime
            , toggleableTimerForm True
            ]
        ]


editableTimerList : List Timer -> Time -> Html Msg
editableTimerList timers currentTime =
    div [ id "timers" ]
        (List.map (editableTimer currentTime) timers)


editableTimer : Time -> Timer -> Html Msg
editableTimer currentTime timer =
    if timer.editFormOpen then
        timerForm (Just timer)
    else
        timerView timer currentTime


timerForm : Maybe Timer -> Html Msg
timerForm maybeTimer =
    let
        timerForm : TimerForm
        timerForm =
            case maybeTimer of
                Just timer ->
                    { title = timer.title, project = timer.project, submitText = "Update" }

                Nothing ->
                    { title = "", project = "", submitText = "Create" }
    in
        div [ class "ui centered card" ]
            [ div [ class "content" ]
                [ div [ class "ui form" ]
                    [ div [ class "field" ]
                        [ label []
                            [ text "Title"
                            , input [ type_ "text", defaultValue timerForm.title ] []
                            ]
                        ]
                    , div [ class "field" ]
                        [ label [] [ text "Project" ]
                        , input [ type_ "text", defaultValue timerForm.project ] []
                        ]
                    , div [ class "ui two bottom attached buttons" ]
                        [ button [ class "ui basic blue button" ] [ text timerForm.submitText ]
                        , button [ class "ui basic red button" ] [ text "Cancel" ]
                        ]
                    ]
                ]
            ]


timerView : Timer -> Time -> Html Msg
timerView timer currentTime =
    let
        elapsedString =
            renderElapsedString timer.elapsed timer.runningSince currentTime
    in
        div [ class "ui centered card" ]
            [ div [ class "content" ]
                [ div [ class "header" ] [ text timer.title ]
                , div [ class "meta" ] [ text timer.project ]
                , div [ class "center aligned description" ] [ h2 [] [ text elapsedString ] ]
                ]
            , div [ class "extra content" ]
                [ span [ class "right floated edit icon" ]
                    [ i [ class "edit icon" ] []
                    ]
                , span [ class "right floated trash icon" ]
                    [ i [ class "trash icon" ] []
                    ]
                ]
            , div [ class "ui bottom attached blue basic button" ] [ text "Start" ]
            ]


toggleableTimerForm : Bool -> Html Msg
toggleableTimerForm isOpen =
    if isOpen then
        timerForm Nothing
    else
        div [] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | currentTime = time }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view, init = init, update = update, subscriptions = subscriptions }
