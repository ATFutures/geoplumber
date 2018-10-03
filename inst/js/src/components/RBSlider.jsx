'use-strict'

import React, { Component } from 'react';
import Control from 'react-leaflet-control';

export default class RBSlider extends Component {

    _handleChange(event) {
        if (typeof (this.props.onChange) === 'function') {
            this.props.onChange(event.target.value)
        }
        this.setState({ value: event.target.value })
    }

    render() {
        const { min, max } = this.props;
        const { value } = this.state;
        return (
            <Control position={
                this.props.position || "topright"
            }>
                <input
                    id="typeinp"
                    type="range"
                    min={min ? min : 1}
                    max={max ? max : 100}
                    value={value ? value : 50}
                    onChange={this._handleChange.bind(this)}
                    step="1" />
            </Control>
        )
    }
}