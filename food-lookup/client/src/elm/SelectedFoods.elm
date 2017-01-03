module SelectedFoods exposing (selectedFoods)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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


sum : List a -> (a -> Float) -> Int
sum foods propFn =
    List.foldl (\food acc -> (propFn food) + acc) 0.0 foods |> round
