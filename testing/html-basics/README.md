# Running

`elm-live src/App.elm --dir=. --pushstate --output=public/elm.js`

# Testing

`elm-test`

# Lessons learned
- elm-html-test can be used to test views
- all selector allows to write useful compound selectors
- consider if unit testing views is a good use of your time (https://groups.google.com/forum/#!topic/elm-discuss/43YU6bsIo5U)
- instead of writing an integration test that simulates clicking (button [onClick Clicked] []) write a separate test for the update function handling
Clicked message and optionally a unit test for the view that takes a current model and renders a view based on it
