import React, { Component } from 'react';
import {
  Marker,
  Circle,
} from "react-google-maps";


class MyMarker extends Component {
  constructor(props) {
    super(props);

  }

  render() {
    return (
      <Marker
      icon={{url:''}}
      position={{lat: this.props.crowd.location.lat, lng: this.props.crowd.location.lng}}
      >

      <Circle
      center={{lat: this.props.crowd.location.lat, lng: this.props.crowd.location.lng}}
      radius={7}
      options={{
        fillColor: '#f00',
        strokeColor: '#f00',
      }}
      />
      </Marker>
    );
  }
}

export default MyMarker;
