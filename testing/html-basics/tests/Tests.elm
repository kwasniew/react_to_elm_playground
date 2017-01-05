module Tests exposing (suite)

import Test exposing (test, Test, describe)
import App exposing (view)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, all, Selector)


addItemButtonSelector : Selector
addItemButtonSelector =
    containsMatchingElement "button" "Add item"


itemsHeaderSelector : Selector
itemsHeaderSelector =
    containsMatchingElement "th" "Items"


containsMatchingElement : String -> String -> Selector
containsMatchingElement tagName txt =
    all [ tag tagName, text txt ]


html : Query.Single
html =
    App.view { items = [], item = "" } |> Query.fromHtml


suite : Test
suite =
    describe "App"
        [ test "should have `th` \"Items\"" <|
            \() ->
                html
                    |> Query.has [ itemsHeaderSelector ]
        , test "should have a `button` element" <|
            \() ->
                html
                    |> Query.has [ addItemButtonSelector ]
        ]
