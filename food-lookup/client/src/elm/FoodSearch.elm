module FoodSearch exposing (foodSearch)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


foodSearch : String -> List Food -> Html Msg
foodSearch searchValue foods =
    div [ id "food-search" ]
        [ table [ class "ui selectable structured large table" ]
            [ thead []
                [ tr []
                    [ th [ colspan 5 ]
                        [ div [ class "ui fluid search" ]
                            [ div [ class "ui icon input" ]
                                [ input [ class "prompt", type_ "text", placeholder "Search foods...", value searchValue, onInput Search ]
                                    []
                                , i [ class "search icon" ] []
                                ]
                            , if searchValue == "" then
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
                    foods
                )
            ]
        ]
