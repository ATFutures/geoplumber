/**
 * ATFutures, LIDA/ITS, University of Leeds
 * Entry component for ATT
 */
import React, { Component } from 'react';
import { Map, TileLayer } from 'react-leaflet';
import GeoJSONComponent from './components/GeoJSONComponent.jsx';
import ControlComponent from './components/ControlComponent.jsx';

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
        const { sfParam } =  this.state;
        return (
            <Map
                zoom={13}
                ref='map'
                center={[53.8008, -1.5491]}
                onclick={(e) => {
                    this.setState({ touchReceived: true })
                }}
            >
                <TileLayer
                    url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    attribution="&copy; <a href=&quot;http://osm.org/copyright&quot;>OpenStreetMap</a> contributors"
                />
                <GeoJSONComponent fetchURL="http://localhost:8000/api/uol" />
                {/* for now below could be part of the boilerplate */}
                <GeoJSONComponent
                    map={this.state.map}
                    fetchURL={"http://localhost:8000/api/gp" + 
                    (this.state.sfParam ?
                        //encode the spaces. 
                        "?road=" + sfParam.split(' ').join("%20") : "")}
                />
                {/* #ADD_COMPONENT */}
            </Map>
        );
    }
}

