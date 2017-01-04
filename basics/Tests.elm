module Tests exposing (..)

import Test exposing (..)
import Expect


all : Test
all =
    describe "My test suite"
        [ test "True should be True" <|
            \() ->
                Expect.equal True True
        ]
