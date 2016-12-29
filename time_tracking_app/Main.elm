module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers exposing (renderElapsedString)
import Time exposing (Time, second)
import Html.Events exposing (..)
import Uuid exposing (Uuid, uuidGenerator, fromString)
import Random.Pcg exposing (Seed, initialSeed, step)
import Http
import Types exposing (..)
import Decoder exposing (timersDecoder, noOp)
import Encoder exposing (..)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { timers =
            []
      , currentTime = flags.now
      , formOpen = False
      , title = ""
      , project = ""
      , currentSeed = initialSeed flags.seed
      , currentUuid = Nothing
      }
    , fetchAllCommand
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
                , span [ class "right floated trash icon", onClick (Delete timer.id) ]
                    [ i [ class "trash icon" ] []
                    ]
                ]
            , timerActionButton timer
            ]


timerActionButton : Timer -> Html Msg
timerActionButton timer =
    if timer.runningSince == Nothing then
        div [ class "ui bottom attached green basic button", onClick (Start timer.id) ] [ text "Start" ]
    else
        div [ class "ui bottom attached red basic button", onClick (Stop timer.id) ] [ text "Stop" ]


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
    forMatchingId id timer { timer | editFormOpen = False, title = timer.prevTitle, project = timer.prevProject }


saveForm : Uuid -> Timer -> Timer
saveForm id timer =
    forMatchingId id timer { timer | editFormOpen = False, prevTitle = timer.title, prevProject = timer.project }


openForm : Uuid -> Timer -> Timer
openForm id timer =
    forMatchingId id timer { timer | editFormOpen = True }


editTitle : Uuid -> String -> Timer -> Timer
editTitle id title timer =
    forMatchingId id timer { timer | title = title }


editProject : Uuid -> String -> Timer -> Timer
editProject id project timer =
    forMatchingId id timer { timer | project = project }


startTimer : Uuid -> Time -> Timer -> Timer
startTimer id now timer =
    forMatchingId id timer { timer | runningSince = Just now }


stopTimer : Uuid -> Time -> Timer -> Timer
stopTimer id now timer =
    forMatchingId id
        timer
        { timer
            | runningSince = Nothing
            , elapsed = timer.elapsed + now - (Maybe.withDefault 0 timer.runningSince)
        }


forMatchingId : Uuid -> Timer -> (Timer -> Timer)
forMatchingId id timer update =
    if timer.id == id then
        update
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


addTimer : List Timer -> Timer -> List Timer
addTimer timers timer =
    List.append timers [ timer ]


startTimerCommand : Uuid -> Time -> Cmd Msg
startTimerCommand id now =
    Http.send Posted <|
        Http.post
            "/api/timers/start"
            (Http.stringBody
                "application/json"
                (Encoder.startTimer id now)
            )
            noOp


stopTimerCommand : Uuid -> Time -> Cmd Msg
stopTimerCommand id now =
    Http.send Posted <|
        Http.post
            "/api/timers/stop"
            (Http.stringBody
                "application/json"
                (Encoder.stopTimer id now)
            )
            noOp


createTimerCommand : Timer -> Cmd Msg
createTimerCommand timer =
    Http.send Posted <|
        Http.post
            "/api/timers"
            (Http.stringBody
                "application/json"
                (Encoder.newTimer timer)
            )
            noOp


fetchAllCommand : Cmd Msg
fetchAllCommand =
    Http.send Fetched <| Http.get "/api/timers" timersDecoder


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

                timer =
                    newTimer model newUuid
            in
                ( { model
                    | currentUuid = Just newUuid
                    , currentSeed = newSeed
                    , timers = addTimer model.timers timer
                    , title = ""
                    , project = ""
                    , formOpen = False
                  }
                , createTimerCommand timer
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

        Delete id ->
            ( { model | timers = List.filter (\t -> t.id /= id) model.timers }, Cmd.none )

        Start id ->
            ( { model | timers = List.map (startTimer id model.currentTime) model.timers }
            , startTimerCommand id model.currentTime
            )

        Stop id ->
            ( { model | timers = List.map (stopTimer id model.currentTime) model.timers }
            , stopTimerCommand id model.currentTime
            )

        FetchAll _ ->
            ( model, fetchAllCommand )

        Fetched response ->
            case response of
                Ok timers ->
                    ( { model | timers = timers }, Cmd.none )

                Result.Err err ->
                    let
                        _ =
                            Debug.log "err" err
                    in
                        ( model, Cmd.none )

        Posted _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ (Time.every 50 Tick), (Time.every 5000 FetchAll) ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view, init = init, update = update, subscriptions = subscriptions }
