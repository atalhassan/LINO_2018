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
      showInfoIndex : -1
    }

  }


      componentDidMount() {
        // Fetch all Mfwejeen from
        db.fetchMfwejeen().child(this.props.campaign_id).on('child_changed', (snapshot) => {
          let crowd = snapshot.val()

          this.props.crowd.location.lat = crowd.lat
          this.props.crowd.location.lng = crowd.lng

          this.setState((prevState, props) => {
            return {[snapshot.key]: crowd
          };
        })
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

    if (this.props.crowd.location=== undefined) {
      return (<div></div>);
    }
    return (
      <Marker
      onClick={()=>{ this.showInfo(this.props.index)} }
      position={{lat: this.props.crowd.location.lat, lng: this.props.crowd.location.lng}}
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
