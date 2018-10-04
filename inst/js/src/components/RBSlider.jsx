'use-strict'

import React, { Component } from 'react';
import Control from 'react-leaflet-control';

export default class RBSlider extends Component {
    constructor(props) {
        super(props);
        this.state = {
            value: null
        }
    }

    _handleChange(event) {
        if (typeof (this.props.onChange) === 'function') {
            this.props.onChange(event.target.value)
        }
        this.setState({ value: event.target.value })
    }

    render() {
        let { min, max } = this.props;
        if(!min) {
            min = 1
        }
        if(!max) {
            max = 100
        }
        const { value } = this.state;
        return (
            <Control position={
                this.props.position || "topright"
            }>
                <div style={{backgroundColor: 'white'}}>
                    <input
                        id="typeinp"
                        type="range"
                        min={min}
                        max={max}
                        value={value ? value : max / 2}
                        onChange={this._handleChange.bind(this)}
                        step="1" />
                    <p style={{textAlign: 'center', fontSize:'2em'}}>{value ? value : max / 2}</p>
                </div>
            </Control>
        )
    }
}