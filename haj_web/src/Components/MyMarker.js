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
      lost: false,
      showInfoIndex : -1,
      ...props
    }
    this.state.intervalId = setInterval(this.timer, 10000);
  }

  timer = () => {
   // setState method is used to update the state
   this.setState({"crowd":  {...this.state.crowd, "lost": true}})

  }

  removeMarker = () => {
   // setState method is used to update the state
   this.setState({"crowd":  {...this.state.crowd, "status": 'Terminated'}})

  }

  componentWillUnmount()  {
     // use intervalId from the state to clear the interval
     clearInterval(this.state.intervalId);
  }
  componentDidMount() {


    this.setState({...this.props})

    // Fetch all Mfwejeen from
    db.fetchMfwejeen().child(this.props.campaign_id).on('child_changed', (snapshot) => {
      let crowd = snapshot.val()

      if (crowd.lat) {
        const lat_1 = parseFloat(this.state.crowd.location.lat)
        const lng_1 = parseFloat(this.state.crowd.location.lng)
        const lat_2 = parseFloat(crowd.lat)
        const lng_2 = parseFloat(crowd.lng)

        const degree = Math.atan2( lng_2 - lng_1,lat_2 - lat_1)
        const distance = Math.pow((lng_2 - lng_1),2) + Math.pow((lat_2 - lat_1),2)

        crowd.heading = degree * (180 / Math.PI)

        clearInterval(this.state.intervalId);
        this.state.intervalId = null
        this.state.intervalId = setInterval(this.timer, 10000);

        this.setState({"crowd":  {...this.state.crowd, "location": crowd, "lost": false, "status":"Active"}})
        // this.setState({"crowd": {"location": crowd}})
      } else if  (!isNaN(crowd))  {
        this.setState({"crowd": {...this.state.crowd , "numberOfPeople": crowd}});
        // this.setState({"crowd": {"numberOfPeople": crowd}})
      } else if (crowd) {
        clearInterval(this.state.intervalId);
        if (crowd === 'inActive') {
          clearInterval(this.state.intervalId);
        } else {
          this.state.intervalId = setInterval(this.timer, 10000);
        }
        this.setState( {"crowd": {...this.state.crowd , "status": crowd}});
      }

  });
}


  showInfo = (a) => {
    if (this.props.crowd.campaign_id !== "" && this.props.crowd.campaign_id !== undefined) {
      db.fetchCampaignWtihId(this.props.crowd.campaign_id)
      .then(snapshot => {
        this.setState(snapshot.val())
      })
    }
   this.setState({showInfoIndex: a })
  }

  onToggleOpen = () => {
   this.setState({showInfoIndex: -1 })
  }


  render() {

    const status = this.state.crowd.status
    const lost = this.state.crowd.lost

    let color = '#00E676'
    let path = window.google.maps.SymbolPath.FORWARD_CLOSED_ARROW
    let scale = 3


    if (lost && status === 'Active' ) {
      color = '#FF1744'
      path = window.google.maps.SymbolPath.CIRCLE
    } else if (status == 'inActive') {
      color = "#2979FF"
      path = window.google.maps.SymbolPath.CIRCLE
      this.state.intervalId = setInterval(this.removeMarker, 10000);
    }

    if (this.state.crowd.numberOfPeople !== undefined) {
      scale =  Math.min(3 +  (parseInt(this.state.crowd.numberOfPeople) / 30),15)
    }


    if (status === 'Terminated') {
      return (<div></div>);
    }
    if (status === 'Active' && !this.props.showActive && !lost) {
      return (<div></div>);
    } else if (status === 'inActive' && !this.props.showInActive ) {
      return (<div></div>);
    } else if (lost && !this.props.showLost ) {
      return (<div></div>);
    } 
    if (this.state.crowd.location === undefined || this.state.crowd.location.lat === undefined) {
      return (<div></div>);
    }
    return (

      <Marker
      onClick={()=>{ this.showInfo(this.props.index)} }
      position={{lat: this.state.crowd.location.lat, lng: this.state.crowd.location.lng}}
      options={{
            icon: {
                path: path,
                scale: scale,
                fillColor: color,
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
              <strong>Crowd ID: </strong>{this.props.campaign_id}<br></br>
              <strong>Name: </strong>{this.state.name}<br></br>
              <strong>Email: </strong><a href="mail:{this.state.email}">{this.state.email}</a><br></br>
              <strong>Phone: </strong><a href="tel:{this.state.phone}">{this.state.phone}</a><br></br>
              <strong>Number Of People: </strong>{this.state.crowd.numberOfPeople}<br></br>

              </div>
          </InfoWindow>}
      </Marker>
    );
  }
}

export default MyMarker;
