# Running the app

1. Ensure you have `npm` and `elm-make` installed.

2. Install all dependencies:

````
npm install
````

3. Boot the HTTP server

````
npm start
````

The server is now running at [localhost:3000](localhost:3000)

# Lessons learned

- no way to quickly hack something like JSON.parse, always have to go through decoders
- using decoders gives you delayed gratification, after some initial struggling you know there's no crappy data in the model
- left pad built into the stdlib :)
- when expanding model/state I tried to avoid modelling things that can be computed/derived from the
existing model
- one model for the entire app is an extreme extension of the idea to move state up to a common ancestor
- one model makes life easier when changes in any part of the app may affect any other part of the app
- when coding in Elm initial commits seem to be less frequent than in JS but once things work there's
no runtime exceptions
- you can't put Date.now() in random parts of the codebase
- when you need current time at app startup time use flags for that
- pure guid handling requires much more work than impure solution in JS
- in Elm you have to explicitly track input changes, you can't access DOM with refs as you'd do in React
- it's nice when compiler guides you what parts of the codebase to update when adding new functionality (e.g. new message
  telling you to change your update function)
- I like record update syntax more than Object.assign({}, original, updated)
- no built in DELETE and PUT helpers but it was easy to built it myself by following POST implementation in Elm sources
