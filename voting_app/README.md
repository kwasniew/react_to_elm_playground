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

- not possible to use local component state, external model required which
is not convenient for quick hacks but good for long term maintenance
- random number generation restricted to init/update functions
