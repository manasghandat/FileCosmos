package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", helloHandler) // register handler function for root path
	http.HandleFunc("/location", locationHandler) // register handler function for location path
	log.Println("Starting server on port 8080")
	log.Fatal(http.ListenAndServe(":8080", nil)) // start server on port 8080
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello, World!") // write response to the client
}

func locationHandler(w http.ResponseWriter, r *http.Request) {
	// get the user's IP address from the request header
	ip := "10.0.2.15"

	const YOUR_MAPBOX_ACCESS_TOKEN = "pk.eyJ1IjoiY29zbWljLWNvZGVyIiwiYSI6ImNsZnRiaXFldDA2c3gzaHBlMDY0a2t2b3gifQ.uESpMXdt9_N9U7l8I9NBhQ";

	// construct a geocoding request URL with the user's IP address as the query and your access token as a parameter
	geocodingURL := fmt.Sprintf("https://api.mapbox.com/geocoding/v5/mapbox.places/%s.json?access_token=%s", ip, YOUR_MAPBOX_ACCESS_TOKEN)

	// make a GET request to the geocoding URL and read the response body as JSON
	resp, err := http.Get(geocodingURL)
	if err != nil {
		log.Println(err)
		http.Error(w, "Something went wrong", http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Println(err)
		http.Error(w, "Something went wrong", http.StatusInternalServerError)
		return
	}

	// parse the JSON response and extract the location information from the first feature
	var data map[string]interface{}
	err = json.Unmarshal(body, &data)
	if err != nil {
		log.Println(err)
		http.Error(w, "Something went wrong", http.StatusInternalServerError)
		return
	}
	features := data["features"].([]interface{})
	if len(features) > 0 {
		feature := features[0].(map[string]interface{})
		placeName := feature["place_name"].(string)
		center := feature["center"].([]interface{})
		lng := center[0].(float64)
		lat := center[1].(float64)
		// write the location information to the client
		fmt.Fprintf(w, "Your location is %s (%f, %f)\n", placeName, lng, lat)
	} else {
		// no features found for the query
		fmt.Fprintln(w, "No location found for your IP address")
	}
}