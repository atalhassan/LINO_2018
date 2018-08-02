import React, { Component } from 'react';
import {
  Marker,
  Circle,
  InfoWindow,
} from "react-google-maps";
import '../Styles/MyMarker.css'
import { db } from '../firebase'


class MyMarker extends Component {
  constructor(props) {
    super(props);
    this.state = {
      showInfoIndex : -1,
      ...props
    }
  }


      componentDidMount() {
        // Fetch all Mfwejeen from
        db.fetchMfwejeen().child(this.props.campaign_id).on('child_changed', (snapshot) => {
          let crowd = snapshot.val()

          if (crowd.lat) {
            this.setState((prevState, props) => {
              return {"crowd":  {...prevState.crowd, "location": crowd}};
            });
            // this.setState({"crowd": {"location": crowd}})
          } else if  (!isNaN(crowd))  {
            this.setState((prevState, props) => {
              return {"crowd": {...prevState.crowd , "numberOfPeople": crowd}};
            });
            // this.setState({"crowd": {"numberOfPeople": crowd}})
          } else if (crowd) {
            this.setState((prevState, props) => {
              return {"crowd": {...prevState.crowd , "status": crowd}};
            });
          }

      });
    }

  showInfo = (a) => {
    db.fetchCampaignWtihId(this.props.crowd.campaign_id)
    .then(snapshot => {
      this.setState(snapshot.val())
    })
   this.setState({showInfoIndex: a })
  }

  onToggleOpen = () => {
   this.setState({showInfoIndex: -1 })
  }

  render() {
    console.log(this.state.crowd);
    if (this.props.crowd.location=== undefined) {
      return (<div></div>);
    }
    return (

      <Marker
      onClick={()=>{ this.showInfo(this.props.index)} }
      position={{lat: this.state.crowd.location.lat, lng: this.state.crowd.location.lng}}
      options={{
            icon: {
                path: window.google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
                scale: isNaN(this.state.crowd.numberOfPeople) ?  4 :  Math.min(3 +  (parseInt(this.state.crowd.numberOfPeople) / 30),15) ,
                fillColor: this.state.crowd.status === "Active" ? 'blue' : 'red',
                fillOpacity: 1,
                strokeWeight: 1,
                rotation: this.state.crowd.location.heading === undefined ?  0 :  this.state.crowd.location.heading,
            },
            }}
      >
      { (this.state.showInfoIndex == this.props.index ) &&
          <InfoWindow  onCloseClick={this.onToggleOpen}>
              <div className="InfoWindow">
              <strong>Campaign id: </strong>{this.props.crowd.campaign_id}<br></br>
              <strong>Name: </strong>{this.state.name}<br></br>
              <strong>Email: </strong><a href="mail:{this.state.email}">{this.state.email}</a><br></br>
              <strong>Phone: </strong><a href="tel:{this.state.phone}">{this.state.phone}</a><br></br>
              </div>
          </InfoWindow>}
      </Marker>
    );
  }
}

export default MyMarker;
