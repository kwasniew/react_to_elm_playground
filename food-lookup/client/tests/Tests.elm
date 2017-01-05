module Tests exposing (..)

import Test exposing (..)
import FoodSearchTests


suite : Test
suite =
    describe "Food Lookup"
        [ FoodSearchTests.suite
        ]
