// pull in desired CSS/SASS files
require('./semantic/dist/semantic.min.css');
require('./styles.css');

// inject bundled Elm app into div#main
var Elm = require( '../elm/App' );
Elm.App.embed( document.getElementById('root'));
