/**
 * geoplumber R package code.
 */
import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter } from 'react-router-dom';

import App from './App';
// TODO: register/unregister needed?
import { unregister } from './registerServiceWorker';

// *** Do NOT remove, it seems the location for icon is missing or something
import L from 'leaflet';
delete L.Icon.Default.prototype._getIconUrl;

L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});
// ***end

/**
 * Separating index.js and App.js has the benefit of
 * doing above like launch configs and keep App.js
 * clear for React application.
 */
ReactDOM.render(
    <BrowserRouter>
      <App />
  </BrowserRouter>, document.getElementById('root'));

unregister();
