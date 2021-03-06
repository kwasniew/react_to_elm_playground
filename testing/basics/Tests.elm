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
        , describe "`capitalize:`"
            [ test "capitalizes first letter, lowercases rest" <|
                \() ->
                    let
                        string =
                            "there was one catch, and that was CATCH-22"
                    in
                        Expect.equal (Modash.capitalize string) "There was one catch, and that was catch-22"
            ]
        , describe "`camelCase:`"
            [ test "camelizes string with spaces" <|
                \() ->
                    let
                        string =
                            "customer responded at"
                    in
                        Expect.equal (Modash.camelCase string) "customerRespondedAt"
            , test "camelizes string with underscores" <|
                \() ->
                    let
                        string =
                            "customer_responded_at"
                    in
                        Expect.equal (Modash.camelCase string) "customerRespondedAt"
            ]
        ]
