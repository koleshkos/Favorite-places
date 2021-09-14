const mapElement = document.getElementById('map');
const token = mapElement.dataset.api;
const userId = mapElement.dataset.guestid;

mapboxgl.accessToken = token;

let map = new mapboxgl.Map({
    container: 'map', // container ID
    style: 'mapbox://styles/mapbox/streets-v11', // style URL
    center: [27.567, 	53.89], // starting position [lng, lat]
    zoom: 14 // starting zoom
});

map.on('load', function (e) {
    let response = fetch("/users/" + userId + "/places.json")
        .then(response => response.json())
        .then(data => {
            data.places.forEach(element => {
                addMarker(element, [element.longitude, element.latitude])
            })
      });
});

function addMarker(place, coordinates) {
    let marker = new mapboxgl.Marker();
    let popup = new mapboxgl.Popup({offset: 25})
        .setHTML(createMarkerPopupWindow(place));

    marker.setLngLat(coordinates)
          .setPopup(popup)
          .addTo(map);
}

function createMarkerPopupWindow(place){
    let html = document.createElement('div');

    html.innerHTML = `
        <div class="title lead" id="title">${place.title}</div>
        <div class="description" id="description">${place.description}</div>
    `;

    return html.innerHTML;
}
