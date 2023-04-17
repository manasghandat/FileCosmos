package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"net/http"
	"ooad/create_user"
	"ooad/get_file"

	firebase "firebase.google.com/go/v4"
	"google.golang.org/api/option"
	// "cloud.google.com/go/firestore"
	// "google.golang.org/api/option"
)


func main() {
	// Parse command-line arguments
	getFiles := flag.Bool("getfiles", false, "Get files from Firebase Storage")
	createUser := flag.Bool("createuser", false, "Create a user in Firestore")
	port := flag.String("port", "8080", "HTTP server port")
	flag.Parse()

	// Initialize the Firebase app with your project ID
	ctx := context.Background()
	conf := &firebase.Config{ProjectID: "location-based-file-sharing"}
	app, err := firebase.NewApp(ctx, conf, option.WithCredentialsFile("../../backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json"))
	if err != nil {
		panic(err)
	}

	// Create a Firestore client
	client, err := app.Firestore(ctx)
	if err != nil {
		panic(err)
	}
	defer client.Close()

	// Execute the selected operation
	if *getFiles {
		// Start the HTTP server to get files
		http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
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

		fmt.Println("Starting HTTP server to get files...")
		http.ListenAndServe(fmt.Sprintf(":%s", *port), nil)
	} else if *createUser {
		// Define the user data
		// var user User
		user := create_user.User{
			Name:  "Jarin Grover",
			Email: "johndoe@example.com",
			Age:   30,
		}

		// Start the HTTP server to create a user
		http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			// Decode the request body into a User struct

			err := json.NewDecoder(r.Body).Decode(&user)
			if err != nil {
				http.Error(w, err.Error(), http.StatusBadRequest)
				return
			}
			
			// Create the user in Firestore
			err = create_user.CreateUser(ctx, client, user)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}

			// Write a success message to the response writer
			w.Header().Set("Content-Type", "text/plain")
			fmt.Fprint(w, "User created successfully")
		})

		fmt.Println("Starting HTTP server to create a user...")
		http.ListenAndServe(fmt.Sprintf(":%s", *port), nil)
	} else {
		fmt.Println("Please specify an operation with the -getfiles or -createuser flag.")
	}
}
