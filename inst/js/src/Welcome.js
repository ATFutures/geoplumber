/**
 * ATFutures, LIDA/ITS, University of Leeds
 * Entry component for ATT
 */
import React, { Component } from 'react';
import { Map, TileLayer } from 'react-leaflet';
import Control from 'react-leaflet-control';

import GeoJSONComponent from './components/GeoJSONComponent.jsx';

import './App.css';

export default class Welcome extends Component {
    constructor(props) {
        super(props);
        this.state = {
            sfParam: null,
            map: null
        }
    }

    componentDidMount() {
        const map = this.refs.map.leafletElement
        this.setState({ map })
    }

    render() {
        return (
            <Map
                preferCanvas={true}
                zoom={13}
                ref='map'
                center={[53.8008, -1.5491]}
                onclick={(e) => {
                    this.setState({ touchReceived: true })
                }}
            >
                <Control className="leaflet-control-attribution leaflet-control"
                    position={this.props.position || "bottomright"}>
                    {this.state.label}
                </Control>
                <TileLayer
                    url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    attribution="&copy; <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors"
                />
                <GeoJSONComponent fetchURL="http://localhost:8000/api/uol" />
                {/* #ADD_COMPONENT */}
            </Map>
        );
    }
}

