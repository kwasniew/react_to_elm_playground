module Tests exposing (..)

import Test exposing (..)
import Expect
import Modash


all : Test
all =
    describe "Modash"
        [ test "`truncate`: trauncates a string" <|
            \() ->
                let
                    string =
                        "there was one catch, and that was CATCH-22"
                in
                    Expect.equal (Modash.truncate string 19) "there was one catch..."
        ]
