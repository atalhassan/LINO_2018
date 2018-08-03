import React, { Component } from 'react';
import Map from './Map'
import '../Styles/App.css'
import { db } from '../firebase'

const byPropKey = (propertyName, value) => () => ({
  [propertyName]: value,
});


const INITIAL_STATE = {
  searchQuery : '',
  showActive : true,
  showInActive : true,
  showLost : true,};

class App extends Component {

  constructor(props) {
  super(props);

  this.state = { ...INITIAL_STATE  , ActiveCounter: 0, InActiveCounter: 0};
  }


  handleShowActive = (e) => {
    if (e.target.checked) {

      this.setState({"showActive" : true})
    } else {

      this.setState({"showActive" : false})
    }
  }

  handleShowInActive = (e) => {
    if (e.target.checked) {

      this.setState({"showInActive" : true})
    } else {

      this.setState({"showInActive" : false})
    }
  }
  handleShowLost = (e) => {
    if (e.target.checked) {

      this.setState({"showLost" : true})
    } else {

      this.setState({"showLost" : false})
    }
  }

  handleSearch = (e) => {
    console.log(e.target.value);
  }

  render() {

    const {
      searchQuery,
      showActive,
      showInActive,
      showLost,
    } = this.state;

    return (
      <div className="App">
      <div className='test'>
      <input type="search"  value={searchQuery} onChange={this.handleSearch} placeholder='Search'/>


      <label className="container">
          <input type="checkbox"  checked={showActive} onChange={this.handleShowActive} /> Active<br></br>
        <span className="checkmark"></span>
      </label>
      <label className="container">
        <input type="checkbox"   checked={showInActive} value={showInActive} onChange={this.handleShowInActive}  /> inActive<br></br>
        <span className="checkmark"></span>
      </label>
      <label className="container">
      <input type="checkbox" checked={showLost} value={showLost} onChange={this.handleShowLost} /> Lost<br></br>
        <span className="checkmark"></span>
      </label>

      <img className='logo' src='tafweej_icon.png'/>

      </div>
      <Map {...this.state}/>
      </div>
    );
  }
}

export default App;
