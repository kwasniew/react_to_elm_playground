module Tests exposing (suite)

import Test exposing (test, Test, describe)
import App exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, attribute, boolAttribute, text, all, Selector)
import Expect


html : Model -> Query.Single
html model =
    App.view model |> Query.fromHtml


model : Model
model =
    { items = [], item = "" }


suite : Test
suite =
    describe "App"
        [ test "should have `th` \"Items\"" <|
            \() ->
                html model
                    |> Query.has [ all [ tag "th", text "Items" ] ]
        , test "should have a `button` element" <|
            \() ->
                html model
                    |> Query.has [ all [ tag "button", boolAttribute "disabled" True, text "Add item" ] ]
        , test "should have an `input` element" <|
            \() ->
                html model |> Query.has [ tag "input" ]
        , describe "the user populates the input"
            [ test "should update the model property `item`" <|
                \() ->
                    Expect.equal
                        (App.update (ItemChange "Vancouver") model)
                        ( { items = [], item = "Vancouver" }, Cmd.none )
            , test "should enable `button`" <|
                \() ->
                    html { items = [], item = "Vancouver" }
                        |> Query.has [ all [ tag "button", boolAttribute "disabled" False ] ]
            ]
        ]
