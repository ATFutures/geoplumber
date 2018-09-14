/**
 * geoplumber R package code.
 */
import React from 'react';
import { GeoJSON } from 'react-leaflet';
import L from 'leaflet';

export default class GeoJSONComponent extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            data: null
        }
    }

    componentDidMount() {
        const url = this.props.fetchURL ? this.props.fetchURL : 'http://localhost:8000/api/data'
        fetch(url)
            .then((response) => {
                if (response.status !== 200) {
                    console.log('Looks like there was a problem. Status Code: ' +
                        response.status);
                    return;
                }
                // Examine the text in the response
                response.json()
                    .then((data) => {
                        if (data.features.length === 0 || response.status === 'ZERO_RESULTS') {
                            this.setState({ error: response.status })
                        } else {
                            var geojsonLayer = L.geoJson(data)
                            const bbox = geojsonLayer.getBounds()
                            // assuming parent has provided "map" object
                            this.props.map && this.props.map.fitBounds(bbox)
                            this.setState({ data })
                        }
                    });
            })
            .catch((err) => {
                console.log('Fetch Error: ', err);
            });
    }

    render() {
        if (!this.state.data) {
            return (null) // as per React docs
        }
        return (
            this.state.data.features.map((feature, i) => {
                return (
                    <GeoJSON
                        key={i}
                        // style={
                        // }
                        data={feature}
                        onEachFeature={(feature, layer) => {
                            const properties = Object.keys(feature.properties).map((key, index) => {
                                return(key + " : " +feature.properties[key])
                            })
                            console.log(feature.properties)
                            console.log(properties)
                            layer.bindPopup(
                                properties.join('<br/>')
                            );                                
                        }}
                    />
                )
            })
        )
    }
}
