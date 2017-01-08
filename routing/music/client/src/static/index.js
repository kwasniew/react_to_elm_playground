// pull in desired CSS/SASS files
require('./styles.css');
require('./semantic/dist/semantic.min.css');

// inject bundled Elm app into div#main
var Elm = require( '../elm/App' );

var LOCAL_STORAGE_KEY = 'fsr-spotify-fake-auth';
var app = Elm.App.embed( document.getElementById('root'), {token : localStorage.getItem(LOCAL_STORAGE_KEY)});

app.ports.setToken.subscribe(function(token) {
  localStorage.setItem(LOCAL_STORAGE_KEY, token);
});

app.ports.removeToken.subscribe(function() {
  localStorage.removeItem(LOCAL_STORAGE_KEY);
});
