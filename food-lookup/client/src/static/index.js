// pull in desired CSS/SASS files
require( './styles/index.css' );
// require('./styles/semantic-ui/semantic.min.css');

// inject bundled Elm app into div#main
var Elm = require( '../elm/App' );
Elm.App.embed( document.getElementById( 'root' ) );
