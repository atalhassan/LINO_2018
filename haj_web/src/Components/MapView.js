import React, { Component } from 'react';
import mapStyle from '../Styles/mapStyle.json'
import {
  withScriptjs,
  withGoogleMap,
  GoogleMap,
} from "react-google-maps";
import MyMarkerClusterer from './MyMarkerClusterer'
import '../Styles/App.css'
const { InfoBox } = require("react-google-maps/lib/components/addons/InfoBox");

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
  

        <MyMarkerClusterer
        />
      </GoogleMap>
    );
  }
}

export default withScriptjs(withGoogleMap(MapView));
