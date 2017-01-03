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

TODO:
- toFixed 2
