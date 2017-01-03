module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { searchValue : String }


model : Model
model =
    { searchValue = "" }



-- UPDATE


type Msg
    = Search String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Search txt ->
            model



-- VIEW


selectedFoods : Model -> Html Msg
selectedFoods model =
    div [] [ text "selected foods" ]


foodSearch : Model -> Html Msg
foodSearch model =
    div [ id "food-search" ]
        [ table [ class "ui selectable structured large table" ]
            [ thead []
                [ tr []
                    [ th [ colspan 5 ]
                        [ div [ class "ui fluid search" ]
                            [ div [ class "ui icon input" ]
                                [ input [ class "prompt", type_ "text", placeholder "Search foods...", value "", onInput Search ]
                                    []
                                , i [ class "search icon" ] []
                                ]
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
            , tbody [] []
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "App" ]
        [ div [ class "ui text container" ]
            [ selectedFoods model
            , foodSearch model
            ]
        ]
