package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"io/ioutil"
	"ooad/file"
	"ooad/user"
	"ooad/models"
	firebase "firebase.google.com/go/v4"
	"google.golang.org/api/option"
	"cloud.google.com/go/storage"

)


func main() {
	// Initialize the Firebase app
	ctx := context.Background()
	opt := option.WithCredentialsJSON(Creds_here))

	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		log.Fatalf("error initializing app: %v", err)
	}

	// Get a Firestore client
	firestoreClient, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalf("error getting Firestore client: %v", err)
	}
	defer firestoreClient.Close()
	

	fileClient, err := storage.NewClient(ctx,opt)
	if err != nil {
		log.Fatalf("error getting storage client: %v", err)
	}
	defer fileClient.Close()

	// Start the HTTP server to get files
	http.HandleFunc("/getFile", func(w http.ResponseWriter, r *http.Request) {
		
		// Read the request body

		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			fmt.Fprint(w, "Failed to read request body")
			return
		}
		
		// get a feild cord from body
		var cordinate models.Cordinate
		
		err = json.Unmarshal(body, &cordinate)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		
		files, err := file.GetFile(ctx, cordinate.Cord,firestoreClient)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		fmt.Println(files)

		// Convert the file struct to JSON and write it to the response writer
		data, err := json.Marshal(files)
		if err != nil {
			panic(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(data)
	})

	http.HandleFunc("/uploadFile",func(w http.ResponseWriter, r *http.Request) {
		s := file.UploadFile(w,r,ctx,fileClient)
		fmt.Println(s)
	})

	// Start the HTTP server to create a user
	http.HandleFunc("/createUser", func(w http.ResponseWriter, r *http.Request) {
		// Decode the request body into a User struct
		// Read the request body
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			fmt.Fprint(w, "Failed to read request body")
			return
		}
		
		var userJson models.User
		err = json.Unmarshal(body, &userJson)

		// Create the user in Firestore
		err = user.CreateUser(ctx, firestoreClient, userJson)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		// Write a success message to the response writer
		w.Header().Set("Content-Type", "text/plain")
		fmt.Fprintln(w, "User created successfully")
	})

	http.HandleFunc("/getUser",func(w http.ResponseWriter, r *http.Request) {
		var userJson models.User
		var username = "Ak"

		userJson, err = user.GetUser(ctx,firestoreClient,username)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return	
		}
		
		data, err := json.Marshal(userJson)
		if err != nil {
			panic(err)
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(data)
	})

	http.HandleFunc("/getAllFiles", func(w http.ResponseWriter, r *http.Request) {

		files, err := file.GetAllFiles(ctx,firestoreClient)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		// Convert the file struct to JSON and write it to the response writer
		data, err := json.Marshal(files)
		if err != nil {
			panic(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(data)
	})

	http.ListenAndServe(":80", nil)
}
