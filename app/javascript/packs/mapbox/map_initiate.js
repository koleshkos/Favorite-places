const mapElement = document.getElementById('map');
const token = mapElement.dataset.api;
const userId = mapElement.dataset.userid;

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

map.on('dblclick', function (e) {
    let coordinates = e.lngLat;

    createInputWindow(coordinates, "POST");
});

function createInputWindow(coordinates, method, place = '') {
    let formHtml = createPlaceFormWindow(place);

    let popup = new mapboxgl.Popup({ closeOnClick: true, offset: [0, -15] })
          .setLngLat(coordinates)
          .setHTML(formHtml)
          .addTo(map);

    let button = document.getElementById("inputButton");

    button.addEventListener('click', function(e) {
        let inputTitle = document.getElementById("title_input").value;
        let inputDescription = document.getElementById("description_input").value;

        let submittedData = {
            title: inputTitle,
            description: inputDescription,
            latitude: coordinates.lat,
            longitude: coordinates.lng,
        };

        path = place ? "/users/" + userId + "/places" + "/" + place.id :
                       "/users/" + userId + "/places"

        let response = fetch(path, {
            method: method,
            headers: {
                "X-CSRF-Token": document
                .getElementsByName("csrf-token")[0]
                .getAttribute("content"),
                "Content-Type": "application/json",
            },
            body: JSON.stringify(submittedData),
            })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    placeErrorsProcessing(data);
                } else {
                    addMarker(data.place, coordinates)
                    popup.remove();
                }
        });
    });
}

function createPlaceFormWindow(place){
    let form = document.createElement('form');
    let title = place ? place.title : '';
    let description = place ? place.description : '';

    form.innerHTML = `
      <h3 class="lead">Add your favorite place</h3><hr/>
      <div class="form-group">
        <label for="title">Title:</label>
        <input type="text" class="form-control" id="title_input" rows="1" value="${title}">
      </div>
      <div class="form-group">
        <label for="description">Description:</label>
        <textarea class="form-control" id="description_input" rows="3">${description}</textarea>
      </div>
      <button id="inputButton" class="btn btn-primary font-weight-bold">Save</button>
    `;

    return form.innerHTML;
}

function addMarker(place, coordinates) {
    let marker = new mapboxgl.Marker();
    let popup = new mapboxgl.Popup({offset: 25})
        .setHTML(createMarkerPopupWindow(place));

    marker.setLngLat(coordinates)
        .setPopup(popup)
        .addTo(map);

    popup.on('open', function() {
        let editButton = document.getElementById("editButton");

        editButton.addEventListener('click', function(e) {
            let path = "/" + place.id;
            createInputWindow(coordinates, "PUT", place);
            popup.remove();
        })

        let deleteButton = document.getElementById("deleteButton");

        deleteButton.addEventListener('click', function(e) {
            let path = "/users/" + userId + "/places" + "/" + place.id;
            let response = fetch(path, {
                method: "DELETE",
                headers: {
                    "X-CSRF-Token": document
                    .getElementsByName("csrf-token")[0]
                    .getAttribute("content"),
                    "Content-Type": "application/json",
                }
            })
            popup.remove();
            marker.remove();
        })
    })
}

function createMarkerPopupWindow(place){
    let html = document.createElement('div');

    html.innerHTML = `
        <div class="title lead" id="title">${place.title}</div>
        <div class="description mb-3" id="description">${place.description}</div>
    `;

    let editButton = document.createElement("BUTTON");
    editButton.innerHTML = "Edit";
    editButton.setAttribute("id", "editButton");
    editButton.setAttribute("class", "btn btn-primary btn-sm mr-2");

    let deleteButton = document.createElement("BUTTON");
    deleteButton.innerHTML = "Delete";
    deleteButton.setAttribute("id", "deleteButton");
    deleteButton.setAttribute("class", "btn btn-secondary btn-sm");

    html.appendChild(editButton);
    html.appendChild(deleteButton);

    return html.innerHTML;
}

function placeErrorsProcessing(data){
    if (data.error.title) {
        data.error.title.forEach(element =>
            document.getElementById("title_input")
                    .insertAdjacentHTML('afterend', '<div class="error-message">' + 'Title ' +
                        element + '<br/>' + '</div>'))
    }
    if (data.error.description) {
        data.error.description.forEach(element =>
            document.getElementById("description_input")
                    .insertAdjacentHTML('afterend', '<div class="error-message">' + 'Description ' +
                        element + '<br/>' + '</div>'))
    }
}
