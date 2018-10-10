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
        let { min, max, step } = this.props;
        min = min || 1
        max = max || 10
        step = step || 1
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
                        step={step}
                        value={value ? value : min}
                        onChange={this._handleChange.bind(this)}
                        />
                    <p style={{textAlign: 'center', fontSize:'2em'}}>{value ? value : min}</p>
                </div>
            </Control>
        )
    }
}
