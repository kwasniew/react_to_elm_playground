This project contains a Node API server and an Elm app generated with elm-webpack-starter under `client/`.

To run, first install dependencies for both:

```
$ npm i && cd client && npm i && cd ..
```

Then boot both the server and the client with:

```
$ npm start
```

Lessons learned:
- you can't introspect Html Attributes: https://groups.google.com/forum/#!searchin/elm-discuss/introspect$20attribute%7Csort:relevance/elm-discuss/KHoBr1me8_4/igVHjbUaPLsJ
- whitespace has meaning in case expressions
- would be nice to have independent and fast Elm dev server with Webpack like historyApiFallback (for SPA routing) and proxy (for relative server API paths in client code).
- when should we use type alias for different pages vs using only Location with pathname?
