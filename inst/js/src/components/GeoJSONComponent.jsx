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
            geojson: null
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
                    .then((geojson) => {
                        if (geojson.features.length === 0 || response.status === 'ZERO_RESULTS') {
                            this.setState({ error: response.status })
                        } else {
                            var geojsonLayer = L.geoJson(geojson)
                            const bbox = geojsonLayer.getBounds()
                            // assuming parent has provided "map" object
                            this.props.map && this.props.map.fitBounds(bbox)
                            this.setState({ geojson })
                        }
                    });
            })
            .catch((err) => {
                console.log('Fetch Error: ', err);
            });
    }

    render() {
        const { geojson } = this.state;
        if (!geojson) {
            return (null) // as per React docs
        }
        return (
            geojson.features.map((feature, i) => {
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
                            // console.log(feature.properties)
                            // console.log(properties)
                            layer.bindPopup(
                                properties.join('<br/>')
                            );                                
                        }}
                        pointToLayer={
                            // use cricles prop if not 10 markers is enough
                            this.props.circle || geojson.features.length > 10 ?
                            (feature, latlng ) => {
                            // Change the values of these options to change the symbol's appearance
                            let options = {
                              radius: 8,
                              fillColor: "lightgreen",
                              color: "black",
                              weight: 1,
                              opacity: 1,
                              fillOpacity: 0.8
                            }
                                return L.circleMarker( latlng, options );
                            }
                            :
                            (geoJsonPoint, latlng) => {
                                return L.marker(latlng);
                            }
                        }
                    />
                )
            })
        )
    }
}
