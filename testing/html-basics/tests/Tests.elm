module Tests exposing (..)

import Test exposing (..)
import App exposing (view)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)


all : Test
all =
    describe "App"
        [ test "should have correct text" <|
            \() ->
                App.view {}
                    |> Query.fromHtml
                    |> Query.has [ text "App" ]
        ]
