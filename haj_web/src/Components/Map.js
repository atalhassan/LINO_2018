import React, { Component } from 'react';
import {
  withScriptjs,
  withGoogleMap,
  GoogleMap,
  Marker,
  Circle,
} from "react-google-maps";
import mapStyle from '../Styles/mapStyle.json'
import { db } from '../firebase'
const { MarkerClusterer } = require("react-google-maps/lib/components/addons/MarkerClusterer");

// MARK:- initial GoogleMap
const MapView = withScriptjs(withGoogleMap(props =>
  <GoogleMap
  defaultZoom={14}
  defaultOptions={{ styles: mapStyle }}
  defaultCenter={{ lat: 21.411205, lng: 39.892393 }}
  >
  <MarkerClusterer
    averageCenter
    enableRetinaIcons
    gridSize={60}
  >
  {
    Object.keys(props.crowds).map((key,i) => (
      <Marker
        key={i}
        position={{lat: props.crowds[key].location.lat, lng: props.crowds[key].location.lng}}
      />
    ))
  }

  </MarkerClusterer>
  </GoogleMap>
));



const byPropKey = (propertyName, value) => () => ({
  [propertyName]: value,
});


// MARK:- initial State
const INITIAL_STATE = {
  crowds: {},
};

// MARK:- initial Map Component
class Map extends Component {

  constructor(props) {
    super(props);
    this.state = { ...INITIAL_STATE };
  }


  componentDidMount() {
    // Fetch all Mfwejeen from database
    db.fetchMfwejeen().once('value').then((snapshot) => {
      let crowds = snapshot.val()
      this.setState({crowds})
    });

    // Fetch all Mfwejeen from
    db.fetchMfwejeen().on('child_changed', (snapshot) => {
      let crowd = snapshot.val()
      this.setState((prevState, props) => {
        return {crowds : {
                        ...prevState.crowds,
                        [snapshot.key]: crowd
                        }
              };
      })

    });
  }

  render() {

    return (
      <div className="Map">
      <MapView
      crowds={this.state.crowds}
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
