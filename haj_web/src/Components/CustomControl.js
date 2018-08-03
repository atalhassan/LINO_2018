import { Component } from 'react';

export default class CustomControl extends Component {
  addToMap(root) {
    console.log(this.props);
    const { ref, controlPosition } = this.props;
    mapHolderRef.getMap().controls[controlPosition].push(root);
  }

  render() {
    <div ref={this.addToMap}>{this.props.children}</div>
  }
}
