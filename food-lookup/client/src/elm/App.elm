module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Client


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
            , Client.search txt
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


sum : List a -> (a -> Float) -> Int
sum foods propFn =
    List.foldl (\food acc -> (propFn food) + acc) 0.0 foods |> round


selectedFoods : List Food -> Html Msg
selectedFoods foods =
    table [ class "ui selectable structured lerge table" ]
        [ thead []
            [ tr []
                [ th [ colspan 5 ]
                    [ h3 []
                        [ text "Selected foods" ]
                    ]
                ]
            , tr []
                [ th [ class "eight wide" ] [ text "Description" ]
                , th [] [ text "Kcal" ]
                , th [] [ text "Protein (g)" ]
                , th [] [ text "Fat (g)" ]
                , th [] [ text "Carbs (g)" ]
                ]
            ]
        , tbody []
            (List.indexedMap
                (\index food ->
                    tr [ onClick (Remove index) ]
                        [ td [] [ text food.description ]
                        , td [ class "right aligned" ] [ text (toString food.kcal) ]
                        , td [ class "right aligned" ] [ text (toString food.protein_g) ]
                        , td [ class "right aligned" ] [ text (toString food.fat_g) ]
                        , td [ class "right aligned" ] [ text (toString food.carbohydrate_g) ]
                        ]
                )
                foods
            )
        , tfoot []
            [ tr []
                [ th [] [ text "Total" ]
                , th [ class "right aligned", id "total-kcal" ] [ text (toString (sum foods .kcal)) ]
                , th [ class "right aligned", id "total-protein_g" ] [ text (toString (sum foods .protein_g)) ]
                , th [ class "right aligned", id "total-fat_g" ] [ text (toString (sum foods .fat_g)) ]
                , th [ class "right aligned", id "total-carbohydrate_g" ] [ text (toString (sum foods .carbohydrate_g)) ]
                ]
            ]
        ]


foodSearch : Model -> Html Msg
foodSearch model =
    div [ id "food-search" ]
        [ table [ class "ui selectable structured large table" ]
            [ thead []
                [ tr []
                    [ th [ colspan 5 ]
                        [ div [ class "ui fluid search" ]
                            [ div [ class "ui icon input" ]
                                [ input [ class "prompt", type_ "text", placeholder "Search foods...", value model.searchValue, onInput Search ]
                                    []
                                , i [ class "search icon" ] []
                                ]
                            , if model.searchValue == "" then
                                text ""
                              else
                                i [ class "remove icon", onClick ClearSearch ] []
                            ]
                        ]
                    ]
                , tr []
                    [ th [ class "eight wide" ] [ text "Description" ]
                    , th [] [ text "Kcal" ]
                    , th [] [ text "Protein (g)" ]
                    , th [] [ text "Fat (g)" ]
                    , th [] [ text "Carbs (g)" ]
                    ]
                ]
            , tbody []
                (List.map
                    (\food ->
                        tr [ onClick (Add food) ]
                            [ td [] [ text food.description ]
                            , td [ class "right aligned" ] [ text (toString food.kcal) ]
                            , td [ class "right aligned" ] [ text (toString food.protein_g) ]
                            , td [ class "right aligned" ] [ text (toString food.fat_g) ]
                            , td [ class "right aligned" ] [ text (toString food.carbohydrate_g) ]
                            ]
                    )
                    model.foods
                )
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "App" ]
        [ div [ class "ui text container" ]
            [ selectedFoods model.selectedFoods
            , foodSearch model
            ]
        ]
