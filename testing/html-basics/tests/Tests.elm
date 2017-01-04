module Tests exposing (..)

import Test exposing (..)
import App exposing (view)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag)


all : Test
all =
    describe "App"
        [ test "should have correct text" <|
            \() ->
                App.view { items = [], item = "" }
                    |> Query.fromHtml
                    |> Query.findAll [ tag "th" ]
                    |> Query.first
                    |> Query.has [ text "Items" ]
        ]
