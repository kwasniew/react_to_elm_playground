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
