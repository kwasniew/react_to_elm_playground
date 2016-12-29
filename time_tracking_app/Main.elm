module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers exposing (renderElapsedString)
import Time exposing (Time, second)
import Html.Events exposing (..)
import Uuid exposing (Uuid, uuidGenerator, fromString)
import Random.Pcg exposing (Seed, initialSeed, step)


type alias Model =
    { timers : List Timer
    , currentTime : Time
    , formOpen : Bool
    , title : String
    , project : String
    , currentSeed : Seed
    , currentUuid : Maybe Uuid
    }


type alias Flags =
    { now : Time, seed : Int }


type alias Timer =
    { title : String
    , project : String
    , prevTitle : String
    , prevProject : String
    , elapsed : Time
    , runningSince : Maybe Time
    , editFormOpen : Bool
    , id : Uuid
    }


type alias TimerForm =
    { title : String
    , project : String
    , submitText : String
    , id : Maybe Uuid
    }


type Msg
    = Tick Time
    | OpenForm
    | Submit (Maybe Uuid)
    | Close (Maybe Uuid)
    | Title (Maybe Uuid) String
    | Project (Maybe Uuid) String
    | Edit Uuid


initTimers : List Timer
initTimers =
    let
        ids =
            [ fromString "63B9AAA2-6AAF-473E-B37E-22EB66E66B76", fromString "63B9AAA2-6AAF-473E-B37E-22EB66E66B77" ]
    in
        case ids of
            [ Just uuid1, Just uuid2 ] ->
                [ { title = "Learn Elm"
                  , project = "Web Domination"
                  , prevTitle = "Learn Elm"
                  , prevProject = "Web Domination"
                  , elapsed = 8986300
                  , runningSince = Nothing
                  , editFormOpen = False
                  , id = uuid1
                  }
                , { title = "Learn extreme ironing"
                  , project = "World Domination"
                  , prevTitle = "Learn extreme ironing"
                  , prevProject = "World Domination"
                  , elapsed = 3890985
                  , runningSince = Nothing
                  , editFormOpen = True
                  , id = uuid2
                  }
                ]

            _ ->
                []


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { timers =
            initTimers
      , currentTime = flags.now
      , formOpen = False
      , title = ""
      , project = ""
      , currentSeed = initialSeed flags.seed
      , currentUuid = Nothing
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
                [ span [ class "right floated edit icon", onClick (Edit timer.id) ]
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


cancelForm : Uuid -> Timer -> Timer
cancelForm id timer =
    if timer.id == id then
        { timer | editFormOpen = False, title = timer.prevTitle, project = timer.prevProject }
    else
        timer


saveForm : Uuid -> Timer -> Timer
saveForm id timer =
    if timer.id == id then
        { timer | editFormOpen = False, prevTitle = timer.title, prevProject = timer.project }
    else
        timer


openForm : Uuid -> Timer -> Timer
openForm id timer =
    if timer.id == id then
        { timer | editFormOpen = True }
    else
        timer


editTitle : Uuid -> String -> Timer -> Timer
editTitle id title timer =
    if timer.id == id then
        { timer | title = title }
    else
        timer


editProject : Uuid -> String -> Timer -> Timer
editProject id project timer =
    if timer.id == id then
        { timer | project = project }
    else
        timer


newTimer : Model -> Uuid -> Timer
newTimer model newUuid =
    { title = model.title
    , prevTitle = model.title
    , project = model.project
    , prevProject = model.project
    , elapsed = 0
    , runningSince = Nothing
    , editFormOpen = False
    , id = newUuid
    }


addTimer : Model -> Uuid -> List Timer
addTimer model newUuid =
    List.append model.timers [ newTimer model newUuid ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | currentTime = time }, Cmd.none )

        OpenForm ->
            ( { model | formOpen = True }, Cmd.none )

        Submit Nothing ->
            let
                ( newUuid, newSeed ) =
                    Random.Pcg.step uuidGenerator model.currentSeed
            in
                ( { model
                    | currentUuid = Just newUuid
                    , currentSeed = newSeed
                    , timers = addTimer model newUuid
                    , title = ""
                    , project = ""
                    , formOpen = False
                  }
                , Cmd.none
                )

        Submit (Just id) ->
            ( { model | timers = List.map (saveForm id) model.timers }, Cmd.none )

        Close (Just id) ->
            ( { model | timers = List.map (cancelForm id) model.timers }, Cmd.none )

        Close Nothing ->
            ( { model | formOpen = False }, Cmd.none )

        Edit id ->
            ( { model | timers = List.map (openForm id) model.timers }, Cmd.none )

        Title (Just id) title ->
            ( { model | timers = List.map (editTitle id title) model.timers }, Cmd.none )

        Title Nothing title ->
            ( { model | title = title }, Cmd.none )

        Project (Just id) project ->
            ( { model | timers = List.map (editProject id project) model.timers }, Cmd.none )

        Project Nothing project ->
            ( { model | project = project }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view, init = init, update = update, subscriptions = subscriptions }
