import './main.scss';

import { Elm } from './elm/Main.elm';

const app = Elm.Main.init({
  node: document.getElementById('elm-main')
});

// Enable hot reloading :)
if (module.hot) {
  module.hot.accept()
}
