module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Client
import FoodSearch exposing (foodSearch)
import SelectedFoods exposing (selectedFoods)


-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = (\_ -> Sub.none) }



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( { searchValue = ""
      , foods = []
      , selectedFoods = []
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search txt ->
            ( { model
                | searchValue = txt
                , foods =
                    if txt == "" then
                        []
                    else
                        model.foods
              }
            , if txt /= "" then
                Client.search txt
              else
                Cmd.none
            )

        ClearSearch ->
            ( { model | searchValue = "" }, Cmd.none )

        Fetched response ->
            case response of
                Ok foods ->
                    ( { model | foods = List.take 25 foods }, Cmd.none )

                Result.Err err ->
                    let
                        _ =
                            Debug.log "error" err
                    in
                        ( model, Cmd.none )

        Add food ->
            ( { model | selectedFoods = List.append model.selectedFoods [ food ] }, Cmd.none )

        Remove index ->
            ( { model
                | selectedFoods =
                    List.append
                        (List.take index model.selectedFoods)
                        (List.drop (index + 1) model.selectedFoods)
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "App" ]
        [ div [ class "ui text container" ]
            [ selectedFoods model.selectedFoods
            , foodSearch model.searchValue model.foods
            ]
        ]
