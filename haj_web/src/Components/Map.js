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

componentDidMount() {

  this.setState({...this.props})
}

render() {

  return (
    <div className="Map">
      <MapView
        googleMapURL="https://maps.googleapis.com/maps/api/js?key=AIzaSyBvmS_5SD6-OsItntOs_dnLFcjbi_lIsJ8"
        loadingElement={<div style={{ height: `100%` }} />}
        containerElement={<div style={{ height: `100vh` , width: `85%`}} />}
        mapElement={<div style={{ height: `100%` }} />}
        {...this.props}
      >
      </MapView>

    </div>
  );
}
}

export default Map;
