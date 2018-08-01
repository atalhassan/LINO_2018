import React, { Component } from 'react';
import mapStyle from '../Styles/mapStyle.json'
import {
  withScriptjs,
  withGoogleMap,
  GoogleMap,
  Marker,
  Circle,
} from "react-google-maps";
import MyMarkerClusterer from './MyMarkerClusterer'


class MapView extends Component {
  constructor(props) {
    super(props);

  }

  render() {
    return (
      <GoogleMap
      defaultZoom={14}
      defaultOptions={{ styles: mapStyle }}
      defaultCenter={{ lat: 21.411205, lng: 39.892393 }}
      >
        {console.log(this.props.crowds)}
        <MyMarkerClusterer
          crowds={this.props.crowds}
        />
      </GoogleMap>
    );
  }
}

export default withScriptjs(withGoogleMap(MapView));
