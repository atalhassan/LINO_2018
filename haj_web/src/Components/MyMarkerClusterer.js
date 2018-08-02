import React, { Component } from 'react';
import MyMarker from './MyMarker'
import { db } from '../firebase'
const { MarkerClusterer } = require("react-google-maps/lib/components/addons/MarkerClusterer");


class MyMarkerClusterer extends Component {

    constructor(props) {
      super(props);
      this.state = { crowds : {} };
    }


    componentDidMount() {
      // Fetch all Mfwejeen from database
      // db.fetchMfwejeen().on('child_added', (snapshot) => {
      //     console.log(snapshot.val());
      //     this.setState((prevState, props) => {
      //       prevState.crowds[snapshot.key] = {}
      //       return {"crowds": {...prevState.crowds }};
      //     });
      // });


      db.fetchMfwejeen().once('value').then((snapshot) => {
          let crowds = snapshot.val()
          db.fetchMfwejeen().on('child_added', (snapshot) => {
            const dict = {...this.state.crowds}
            dict[snapshot.key] = snapshot.val()
            // const result = Object.values(dict).filter(crowd => crowd.status !== 'Suspended');

            this.setState( {"crowds": dict})
          });
          db.fetchMfwejeen().on('child_removed', (snapshot) => {
            const dict = {...this.state.crowds}
            delete dict[snapshot.key]
            // const result = Object.values(dict).filter(crowd => crowd.status !== 'Suspended');
            this.setState({"crowds": dict})
          });
      });

  }

  render() {
    return (
      <MarkerClusterer
      defaultAverageCenter
      defaultEnableRetinaIcons

      defaultGridSize={25}
      >
      {Object.keys(this.state.crowds).length === 0
        ? <div></div>
        :
        Object.keys(this.state.crowds).map((key,i) => (
          <MyMarker
            key={i}
            campaign_id={key === undefined ? '' : key}
            index={i}
            crowd={this.state.crowds[key].location !== undefined ? this.state.crowds[key] :  this.state.crowds[key]}
            /> )

        )
      }

      </MarkerClusterer>
    );
  }
}

export default MyMarkerClusterer;
