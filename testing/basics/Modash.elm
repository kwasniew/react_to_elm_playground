module Modash exposing (truncate, capitalize, camelCase)

import String exposing (length, slice, left, toUpper, dropLeft, join, toLower)
import Regex exposing (split, HowMany(..), regex)
import List exposing (append, take, drop, map)


truncate : String -> Int -> String
truncate str len =
    if length str > len then
        (slice 0 len str) ++ "..."
    else
        str


capitalize : String -> String
capitalize str =
    (left 1 str |> toUpper) ++ (dropLeft 1 (toLower str))


camelCase : String -> String
camelCase str =
    let
        words =
            split All (regex "/[\\s|\\-|_]+/") str

        first =
            take 1 words |> map toLower

        tail =
            drop 1 words |> map capitalize
    in
        append first tail |> join ""
