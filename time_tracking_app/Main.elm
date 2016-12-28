module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { timers : List Timer
    }


type alias Timer =
    { title : String
    , project : String
    , elapsed : Int
    , runningSince : Maybe Int
    , editFormOpen : Bool
    }


type alias TimerForm =
    { title : String
    , project : String
    , submitText : String
    }


type Msg
    = NoOp


init : ( Model, Cmd Msg )
init =
    ( { timers =
            [ { title = "Learn Elm", project = "Web Domination", elapsed = 8986300, runningSince = Nothing, editFormOpen = False }
            , { title = "Learn extreme ironing", project = "World Domination", elapsed = 3890985, runningSince = Nothing, editFormOpen = True }
            ]
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
            [ editableTimerList model.timers
            , toggleableTimerForm True
            ]
        ]


editableTimerList : List Timer -> Html Msg
editableTimerList timers =
    div [ id "timers" ]
        (List.map editableTimer timers)


editableTimer : Timer -> Html Msg
editableTimer timer =
    if timer.editFormOpen then
        timerForm (Just timer)
    else
        timerView timer


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


timerView : Timer -> Html Msg
timerView timer =
    div [] []


toggleableTimerForm : Bool -> Html Msg
toggleableTimerForm isOpen =
    div [] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
