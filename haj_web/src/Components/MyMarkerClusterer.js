import React, { Component } from 'react';
import MyMarker from './MyMarker'
import { db } from '../firebase'
const { MarkerClusterer } = require("react-google-maps/lib/components/addons/MarkerClusterer");
const { SearchBox } = require("react-google-maps/lib/components/places/SearchBox");


class MyMarkerClusterer extends Component {

    constructor(props) {
      super(props);
      this.state = { crowds : {} };
    }


    componentDidMount() {
      // Fetch all Mfwejeen from database
      db.fetchMfwejeen().once('value').then((snapshot) => {
        let crowds = snapshot.val()
        this.setState({crowds})
      });

  }

  render() {
    console.log(this.state.crowds);
    return (
      <MarkerClusterer
      averageCenter
      enableRetinaIcons
      gridSize={60}
      >
      {Object.keys(this.state.crowds).length === 0
        ? <div></div>
        :
        Object.keys(this.state.crowds).map((key,i) => (
          <MyMarker
            key={i}
            campaign_id={key}
            index={i}
            crowd={this.state.crowds[key].location !== undefined ? this.state.crowds[key] : []}
            /> )

        )
      }

      </MarkerClusterer>
    );
  }
}

export default MyMarkerClusterer;
