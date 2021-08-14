/**
 * geoplumber R package code.
 */
import React, { Component } from 'react';
import { Switch, Route } from 'react-router-dom';

import Home from './Home';
import Header from './components/Header';

import './App.css';


/**
 * Separate the Header and the main content.
 * Up to this point we are still not using SSR
 */
class App extends Component {
  render() {
    return (
      <main>
        <Header />
        <Switch>
          <Route exact path="/" component={Welcome} />
          <Route exact path="/about" component={() => <p>About...</p>} />
          <Route exact path="/test" component={() => <p>Test...</p>} />
        </Switch>
      </main>
    )
  }
}

export default App;
