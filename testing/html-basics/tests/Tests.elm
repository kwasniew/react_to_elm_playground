module Tests exposing (suite)

import Test exposing (test, Test, describe)
import App exposing (view)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, all, Selector)


element : String -> String -> Selector
element tagName txt =
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
                    |> Query.has [ element "th" "Items" ]
        , test "should have a `button` element" <|
            \() ->
                html
                    |> Query.has [ element "button" "Add item" ]
        , test "should have an `input` element" <|
            \() ->
                html |> Query.has [ tag "input" ]
        ]
