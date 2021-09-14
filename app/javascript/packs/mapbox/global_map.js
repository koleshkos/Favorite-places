const mapElement = document.getElementById('map');
const token = mapElement.dataset.api;
const users = mapElement.dataset.users;

mapboxgl.accessToken = token;

let map = new mapboxgl.Map({
    container: 'map', // container ID
    style: 'mapbox://styles/mapbox/streets-v11', // style URL
    center: [27.567, 	53.89], // starting position [lng, lat]
    zoom: 14 // starting zoom
});

map.on('load', function (e) {
    let users_response = fetch("/global_map/users.json")
        .then(response => response.json())
        .then(data => {
            data.forEach(user => {
                user.places.forEach(place => {
                    addMarker(place, [place.longitude, place.latitude], user);
                });
            });
        });
});

function addMarker(place, coordinates, author) {
    let marker = new mapboxgl.Marker();
    let popup = new mapboxgl.Popup({offset: 25})
        .setHTML(createMarkerPopupWindow(place, author));

    marker.setLngLat(coordinates)
        .setPopup(popup)
        .addTo(map);
}

function createMarkerPopupWindow(place, author){
    let html = document.createElement('div');
    let path = "/users/" + author.id
    html.innerHTML = `
        <div class="title lead" id="title">${place.title}</div>
        <div class="description" id="description">${place.description}</div>
        <div class="author"><a href="${path}">${author.username}</a></div>
    `;

    return html.innerHTML;
}
