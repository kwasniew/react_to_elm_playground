module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers exposing (renderElapsedString)
import Time exposing (Time, second)
import Html.Events exposing (..)


type alias Model =
    { timers : List Timer
    , currentTime : Time
    , formOpen : Bool
    , title : String
    , project : String
    }


type alias Flags =
    { now : Time }


type alias Timer =
    { title : String
    , project : String
    , elapsed : Time
    , runningSince : Maybe Time
    , editFormOpen : Bool
    , id : String
    }


type alias TimerForm =
    { title : String
    , project : String
    , submitText : String
    , id : Maybe String
    }


type Msg
    = Tick Time
    | OpenForm
    | Submit (Maybe String)
    | Close (Maybe String)
    | Title (Maybe String) String
    | Project (Maybe String) String


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { timers =
            [ { title = "Learn Elm", project = "Web Domination", elapsed = 8986300, runningSince = Nothing, editFormOpen = False, id = "1" }
            , { title = "Learn extreme ironing", project = "World Domination", elapsed = 3890985, runningSince = Nothing, editFormOpen = True, id = "2" }
            ]
      , currentTime = flags.now
      , formOpen = False
      , title = ""
      , project = ""
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
            , toggleableTimerForm model.formOpen
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
                    { title = timer.title, project = timer.project, submitText = "Update", id = Just timer.id }

                Nothing ->
                    { title = "", project = "", submitText = "Create", id = Nothing }
    in
        div [ class "ui centered card" ]
            [ div [ class "content" ]
                [ div [ class "ui form" ]
                    [ div [ class "field" ]
                        [ label []
                            [ text "Title"
                            , input [ type_ "text", onInput (Title timerForm.id), defaultValue timerForm.title ] []
                            ]
                        ]
                    , div [ class "field" ]
                        [ label [] [ text "Project" ]
                        , input [ type_ "text", onInput (Project timerForm.id), defaultValue timerForm.project ] []
                        ]
                    , div [ class "ui two bottom attached buttons" ]
                        [ button [ class "ui basic blue button", onClick (Submit timerForm.id) ] [ text timerForm.submitText ]
                        , button [ class "ui basic red button", onClick (Close timerForm.id) ] [ text "Cancel" ]
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
        div [ class "ui basic content center aligned segment" ]
            [ button [ class "ui basic button icon", onClick OpenForm ]
                [ i [ class "plus icon" ] []
                ]
            ]


closeForm : String -> Timer -> Timer
closeForm id timer =
    if timer.id == id then
        { timer | editFormOpen = False }
    else
        timer


newTimer : Model -> Timer
newTimer model =
    { title = model.title, project = model.project, elapsed = 0, runningSince = Nothing, editFormOpen = False, id = "3" }


addTimer : Model -> List Timer
addTimer model =
    List.append model.timers [ newTimer model ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | currentTime = time }, Cmd.none )

        OpenForm ->
            ( { model | formOpen = True }, Cmd.none )

        Submit Nothing ->
            ( { model | timers = addTimer model, title = "", project = "", formOpen = False }, Cmd.none )

        Submit (Just id) ->
            ( model, Cmd.none )

        Close (Just id) ->
            ( { model | timers = List.map (closeForm id) model.timers }, Cmd.none )

        Close Nothing ->
            ( { model | formOpen = False }, Cmd.none )

        Title (Just id) title ->
            ( model, Cmd.none )

        Title Nothing title ->
            ( { model | title = title }, Cmd.none )

        Project Nothing project ->
            ( { model | project = project }, Cmd.none )

        Project (Just id) project ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view, init = init, update = update, subscriptions = subscriptions }
