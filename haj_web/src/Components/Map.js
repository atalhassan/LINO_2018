import React, { Component } from 'react';
import MapView from './MapView'




const byPropKey = (propertyName, value) => () => ({
  [propertyName]: value,
});


// MARK:- initial State
const INITIAL_STATE = {

};

// MARK:- initial Map Component
class Map extends Component {

  constructor(props) {
    super(props);

  }


render() {
console.log("reloded");
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
