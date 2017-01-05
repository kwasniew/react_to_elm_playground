module Tests exposing (..)

import Test exposing (test, Test, describe)
import App exposing (view)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, all, Selector)


addItemButtonSelector : Selector
addItemButtonSelector =
    Test.Html.Selector.all [ tag "button", text "Add item" ]


itemsHeaderSelector : Selector
itemsHeaderSelector =
    Test.Html.Selector.all [ tag "th", text "Items" ]


all : Test
all =
    describe "App"
        [ test "should have `th` \"Items\"" <|
            \() ->
                App.view { items = [], item = "" }
                    |> Query.fromHtml
                    |> Query.has [ itemsHeaderSelector ]
        , test "should have a `button` element" <|
            \() ->
                App.view { items = [], item = "" }
                    |> Query.fromHtml
                    |> Query.has [ addItemButtonSelector ]
        ]
