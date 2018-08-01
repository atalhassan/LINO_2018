import React, { Component } from 'react';
import MyMarker from './MyMarker'
const { MarkerClusterer } = require("react-google-maps/lib/components/addons/MarkerClusterer");


class MyMarkerClusterer extends Component {
  constructor(props) {
    super(props);

  }

  render() {
    return (
      <MarkerClusterer
      averageCenter
      defaultMaxZoom={16}
      enableRetinaIcons
      gridSize={10}
      >
      {
        Object.keys(this.props.crowds).map((key,i) => (
          <MyMarker
            key={i}
            crowd={this.props.crowds[key]}
          />
        ))
      }

      </MarkerClusterer>
    );
  }
}

export default MyMarkerClusterer;
