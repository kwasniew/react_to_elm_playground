module FoodSearchTests exposing (suite)

import Test exposing (..)
import Expect
import FoodSearch exposing (foodSearch)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, attribute, boolAttribute, text, all, classes, Selector)
import App
import Types exposing (..)


item1 : Food
item1 =
    { description = "Broccolini"
    , kcal = 100
    , protein_g = 11
    , fat_g = 21
    , carbohydrate_g = 31
    }


item2 : Food
item2 =
    { description = "Broccoli rabe"
    , kcal = 200
    , protein_g = 12
    , fat_g = 22
    , carbohydrate_g = 32
    }


foods : List Food
foods =
    [ item1
    , item2
    ]


suite : Test
suite =
    describe "FoodSearch"
        [ test "should not display the remove icon" <|
            \() ->
                foodSearch "" []
                    |> Query.fromHtml
                    |> Query.findAll [ classes [ "remove", "icon" ] ]
                    |> Query.count (Expect.equal 0)
        , test "should display zero rows" <|
            \() ->
                foodSearch "" []
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children [ tag "tr" ]
                    |> Query.count (Expect.equal 0)
        , describe "user populates search field"
            [ test "should update model property `searchValue`" <|
                \() ->
                    Expect.equal
                        (Tuple.first <|
                            App.update (Search "brocc")
                                { searchValue = ""
                                , foods = []
                                , selectedFoods = []
                                }
                        )
                        { searchValue = "brocc"
                        , foods = []
                        , selectedFoods = []
                        }
            , test "should display the remove icon" <|
                \() ->
                    foodSearch "brocc" []
                        |> Query.fromHtml
                        |> Query.findAll [ classes [ "remove", "icon" ] ]
                        |> Query.count (Expect.equal 1)
            ]
        , describe "API return results"
            [ test "should set the model property `foods`" <|
                \() ->
                    Expect.equal
                        (App.update
                            (Fetched (Ok foods))
                            { searchValue = ""
                            , foods = []
                            , selectedFoods = []
                            }
                        )
                        ( { searchValue = ""
                          , foods = foods
                          , selectedFoods = []
                          }
                        , Cmd.none
                        )
            , test "should display two rows" <|
                \() ->
                    foodSearch "" foods
                        |> Query.fromHtml
                        |> Query.find [ tag "tbody" ]
                        |> Query.children [ tag "tr" ]
                        |> Query.count (Expect.equal 2)
            , test "should render the description of first row" <|
                \() ->
                    foodSearch "" foods
                        |> Query.fromHtml
                        |> Query.has [ text "Broccolini" ]
            , test "should render the description of second row" <|
                \() ->
                    foodSearch "" foods
                        |> Query.fromHtml
                        |> Query.has [ text "Broccoli rabe" ]
            ]
        , describe "user clicks food item"
            [ test "should add the item to selected foods" <|
                \() ->
                    Expect.equal
                        (App.update (Add item1)
                            { searchValue = ""
                            , foods = foods
                            , selectedFoods = []
                            }
                        )
                        ( { searchValue = ""
                          , foods = foods
                          , selectedFoods = [ item1 ]
                          }
                        , Cmd.none
                        )
            ]
        , describe "user clicks the remove icon"
            [ test "should set the model property `foods`" <|
                \() ->
                    Expect.equal
                        (App.update
                            ClearSearch
                            { searchValue = "brocc"
                            , foods = foods
                            , selectedFoods = []
                            }
                        )
                        ( { searchValue = ""
                          , foods = []
                          , selectedFoods = []
                          }
                        , Cmd.none
                        )
            ]
        ]
