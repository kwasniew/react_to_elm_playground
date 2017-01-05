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
- Elm attribute types are not just strings e.g. colspan has to be an int
- Webpack has some nice features like proxy web dev server but overall I find it too slow to be pleasant to use
- Number.toFixed() is not yet ported to Elm
- describe and test compose very nicely in tests
- it looks like testing Cmd Msg from the update function is problematic: https://groups.google.com/forum/#!searchin/elm-discuss/unit$20test$20cmd%7Csort:relevance/elm-discuss/IYp-bI93AnY/K-m4YwqsAgAJ
- and the reason for that is that commands are not inspectable/comparable: https://groups.google.com/forum/#!searchin/elm-discuss/test$20update$20function%7Csort:relevance/elm-discuss/wx0N8kJ66aw/1c_QYvDeAAAJ
- this project may be helpful for testing effects: https://github.com/avh4/elm-testable

TODO:
- selected foods tests
