import React, { Component } from 'react';
import mapStyle from '../Styles/mapStyle.json'
import {
  withScriptjs,
  withGoogleMap,
  GoogleMap,
  OverlayView,
} from "react-google-maps";
import MyMarkerClusterer from './MyMarkerClusterer'
import '../Styles/App.css'
// import CustomControl from './CustomControl'





class MapView extends Component {
  constructor(props) {
    super(props);
  }


  componentDidMount() {

    this.setState({...this.props})
  }

  render() {

    return (
      <GoogleMap
      defaultZoom={14}
      defaultOptions={{ styles: mapStyle }}
      defaultCenter={{ lat: 21.411205, lng: 39.892393 }}
      >

      <MyMarkerClusterer
        {...this.props}
      />
      </GoogleMap>

    );
  }
}

export default withScriptjs(withGoogleMap(MapView));
