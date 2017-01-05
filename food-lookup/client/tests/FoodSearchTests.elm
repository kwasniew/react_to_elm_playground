module FoodSearchTests exposing (all)

import Test exposing (..)
import Expect
import FoodSearch exposing (foodSearch)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, attribute, boolAttribute, text, all, classes, Selector)


all : Test
all =
    describe "FoodSearch"
        [ test "should not display the remove icon" <|
            \() ->
                foodSearch "" []
                    |> Query.fromHtml
                    |> Query.findAll [ classes [ ".remove", ".icon" ] ]
                    |> Query.count (Expect.equal 0)
        , test "should display zero rows" <|
            \() ->
                foodSearch "" []
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children [ tag "tr" ]
                    |> Query.count (Expect.equal 0)
        ]
