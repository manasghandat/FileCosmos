package main

import (
	"encoding/json"
	// "fmt"
	"net/http"
	"ooad/get_file"
)

func main() {
	http.HandleFunc("/file", func(w http.ResponseWriter, r *http.Request) {
		bucketName := "location-based-file-sharing.appspot.com"
		objectName := "Prog.txt"

		// Get the file from Firebase Storage
		file, err := get_file.GetFile(bucketName, objectName)
		if err != nil {
			panic(err)
		}

		// Convert the file struct to JSON and write it to the response writer
		data, err := json.Marshal(file)
		if err != nil {
			panic(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(data)
	})

	http.ListenAndServe(":8080", nil)
}
