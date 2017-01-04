module Tests exposing (..)

import Test exposing (..)
import Expect
import Modash


all : Test
all =
    describe "Modash"
        [ describe "`truncate:`"
            [ test "truncates a string" <|
                \() ->
                    let
                        string =
                            "there was one catch, and that was CATCH-22"
                    in
                        Expect.equal (Modash.truncate string 19) "there was one catch..."
            , test "no-ops if <= length" <|
                \() ->
                    let
                        string =
                            "there was one catch, and that was CATCH-22"
                    in
                        Expect.equal (Modash.truncate string (String.length string)) string
            ]
        ]
