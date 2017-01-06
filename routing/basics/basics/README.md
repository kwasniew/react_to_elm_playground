# Routing basics

## Running


```
elm-live src/App.elm --dir=. --pushstate --output=public/elm.js --debug
```

The app will be available at `http://localhost:8000`


notes:
- own routing - lots of library magic: childContextTypes, getChildContext, forceUpdate on history changes
childContextTypes
components getting magical context param
- impure history and location references from inside router
- by default onClick on anchor tag doesn't prevent default so you have to write one
