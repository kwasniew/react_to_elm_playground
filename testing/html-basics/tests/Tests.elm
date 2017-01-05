module Tests exposing (suite)

import Test exposing (test, Test, describe)
import App exposing (view)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, attribute, boolAttribute, text, all, Selector)


html : Query.Single
html =
    App.view { items = [], item = "" } |> Query.fromHtml


suite : Test
suite =
    describe "App"
        [ test "should have `th` \"Items\"" <|
            \() ->
                html
                    |> Query.has [ all [ tag "th", text "Items" ] ]
        , test "should have a `button` element" <|
            \() ->
                html
                    |> Query.has [ all [ tag "button", boolAttribute "disabled" True, text "Add item" ] ]
        , test "should have an `input` element" <|
            \() ->
                html |> Query.has [ tag "input" ]
        ]
