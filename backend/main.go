package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"ooad/create_user"
	"ooad/get_file"

	// "cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"google.golang.org/api/option"
)

func main() {
	// Define the user data
	user := create_user.User{
		Name:         "John Doe",
		EmailAddress: "johndoe@example.com",
		Age:          30,
	}

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

	// Create the user in Firestore
	err = create_user.CreateUser(ctx, client, user)
	if err != nil {
		panic(err)
	}

	// Print a success message
	fmt.Println("User created successfully")

	// Start the HTTP server to get files
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

// package main

// import (
// 	"encoding/json"
// 	// "fmt"
// 	"net/http"
// 	"ooad/get_file"
// )

// func main() {
// 	// int action = 0
// 	http.HandleFunc("/file", func(w http.ResponseWriter, r *http.Request) {
// 		bucketName := "location-based-file-sharing.appspot.com"
// 		objectName := "Prog.txt"

// 		// Get the file from Firebase Storage
// 		file, err := get_file.GetFile(bucketName, objectName)
// 		if err != nil {
// 			panic(err)
// 		}

// 		// Convert the file struct to JSON and write it to the response writer
// 		data, err := json.Marshal(file)
// 		if err != nil {
// 			panic(err)
// 		}
// 		w.Header().Set("Content-Type", "application/json")
// 		w.Write(data)
// 	})

// 	http.ListenAndServe(":8080", nil)
// }
