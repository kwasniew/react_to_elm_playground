# Routing basics

## Running


```
elm-live src/App.elm --dir=. --pushstate --output=public/elm.js --debug
```

The app will be available at `http://localhost:8000`


Lessons learned:
- custom react routing from the book - lots of library magic: childContextTypes, getChildContext, childContextTypes, forceUpdate on history changes, components getting context param
- custom react routing from the book - impure history and location references from inside router
- elm: by default onClick on anchor tag doesn't prevent default so you have to write custom handler
- react router is very impure with things like Redirect, Link or Miss taking actions at a distance in some
implicit context
- react router seems to be mixing redirection logic with views
- Elm has a very interesting approach to default values for record properties: https://groups.google.com/forum/#!topic/elm-discuss/NJYTjCXzlfY
- url parser should be able to consume remaining path soon: https://github.com/evancz/url-parser/pull/25/files
