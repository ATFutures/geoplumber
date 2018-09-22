'use-strict'

import React, { Component } from 'react';
import Control from 'react-leaflet-control';
import RBDropdownComponent from './RBDropdownComponent';

export default class ControlComponent extends Component {

    render() {
        return(
            <Control position={
                this.props.position || "topright"
            }>
                <RBDropdownComponent
                    classNames={[]}
                    title={this.props.title || "None"}
                    size={this.props.size || "dropdown-size-medium"}
                    onSelectCallback={(event) => {
                        if (typeof (this.props.onSelectCallback) === 'function') {
                            this.props.onSelectCallback(event)
                        }
                    }}
                    menuitems={this.props.menuitems || []}
                />
            </Control>
        )
    }
}
