# Running the app

1. Ensure you have `elm` installed.

2. Install dependencies

````
elm-package install
````

3. Run app

````
elm-live Main.elm --dir=. --pushstate --output=elm.js
````

The server is now running at [localhost:8000](localhost:8000)

# Lessons learned
- onInput works with dropdown
- use localStorage via ports until https://github.com/elm-lang/persistent-cache is ready
- looks like Elm community discourages premature splitting of code and with an advanced compiler you can defer it
- when writing a union type to model state transitions I find proper order makes it easier to reason about code (e.g. Ready -> Saving -> Success/Error)
- I find Elm messages much more explicit than Redux mapDispatchToProps, mapStateToProps, applyMiddleware, JSX Provider etc.
- gotcha: JSX value on select element does not work in Elm
- Process.sleep can be used to convert setTimeout to Elm
