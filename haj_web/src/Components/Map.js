import React, { Component } from 'react';
import {
  withScriptjs,
  withGoogleMap,
  GoogleMap,
  Marker,
} from "react-google-maps";
import mapStyle from '../Styles/mapStyle.json'


// MARK:- initial GoogleMap
const MapView = withScriptjs(withGoogleMap(props =>
  <GoogleMap
  defaultZoom={14}
  defaultOptions={{ styles: mapStyle }}
  defaultCenter={{ lat: 21.411205, lng: 39.892393 }}
  >
  <Marker
  position={{ lat: 21.411205, lng: 39.892393 }}
  />
  </GoogleMap>
));

// MARK:- initial Map Component
class Map extends Component {
  render() {
    return (
      <div className="Map">
        <MapView
          googleMapURL="https://maps.googleapis.com/maps/api/js?key=AIzaSyBvmS_5SD6-OsItntOs_dnLFcjbi_lIsJ8"
          loadingElement={<div style={{ height: `100%` }} />}
          containerElement={<div style={{ height: `100vh` }} />}
          mapElement={<div style={{ height: `100%` }} />}
        />
      </div>
    );
  }
}

export default Map;
