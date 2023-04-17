package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"net/http"
	"ooad/create_user"
	"ooad/get_file"
	"log"

	firebase "firebase.google.com/go/v4"
	"google.golang.org/api/option"
	// "cloud.google.com/go/firestore"
	// "google.golang.org/api/option"
)


func main() {
	// Parse command-line arguments
	getFiles := flag.Bool("g", false, "Get files from Firebase Storage")
	createUser := flag.Bool("c", false, "Create a user in Firestore")
	port := flag.String("p", "8080", "HTTP server port")
	flag.Parse()

	// Initialize the Firebase app
	ctx := context.Background()
	opt := option.WithCredentialsJSON([]byte(`{
		"type": "service_account",
		"project_id": "location-based-file-sharing",
		"private_key_id": "fb430b4173f26c315476891a34b759457f18dd08",
		"private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC07msR8IuWeeNA\nlGq0Ynl2nGfYx/eceMRJ2efqP6iDY0dfoyiwrTrs1Xhm1883AIWNqlTeA0ehfmfr\nqQo+09OPTUpWR7WOIDSlMELiRhXnLaxVolANxx3ZJrceTOiyf7sCKHmp9IgfCybN\nml82iiSz8N7FvxtOVekjKU/6/5IkziOaulaqVsjNGSd6oWuHo/K73g7aPH+qlD+f\nuLe0sEeywXeHaCenA15VXQ6nLyk8lkJNgGoNHLz0gPrHhyh25UkUnbNgo/OOfChn\nanp2WRxaqUEnYeuRw0Bm3k7mAro8T77vAv6MOzAMl7ubukp+XJRcEmqsJs3lmC1D\nU4HdfrRDAgMBAAECggEAAIGwZA733RZ/R+WCfPnPnEDo24cHzvTZm9lT2GiQOLn0\n77Qdv4zkntgkK6mMB3vlY9Wnwi1hLHcVpGfHQxDFxV9yh1ZREFJPw2ykq0yF8C1F\nD8JSFg/KKhr9JUUS27kW1XU2jf7EyM13sNivTpBJdQWGIiicU3ZTHkmV0z6W8qpt\n4frCGqlawPexsilh1/MieSzvNcxcWCYPrTBk9i2QkdIru6Z9J5Rkis/SI5XHUgsC\n7DSsFNeqHA+75pkpJ5FCc8a49Ip4p9bqVFZ4JgkbqqaiA+u+fIjqK7UqWQEPNteK\nwd0w7FhtavqhgClg+VGYt+b1b8pfsk8sSawYTuGJWQKBgQDuHZz6LGzBm0K+BJD7\nYIYq83BjX7el7L6afayrRaHHQ3fpP4ZzIZuTLawaspuvhCVa78eil8iJXJzsDaM8\nCNZiQbhGMjqX4llHmsbIVo0vRXTKT+DMzC/2SDkgP3huZ4gX53fgS/OthwihKGVL\nfN0RSXNLYZFiTepYmYmc/6xLawKBgQDChUnjOwHc5HuArnTgsULblD2y07TISixi\nhE1oaL3wM6kLZCvq1Y6vqlLaRwBst0fL29h3OEyYbCndbyq4fji6IXmuYiHvHm9f\nZmFyo/j8EUylgKWFnqaIum1NGykITn5FgP0dgKl/Khy7356/QOBrW53zshXJgYoe\n0bZj2o0IiQKBgQDAwe46w03DKOnNoyqupEPYbzty5qBnTJA7xjLKb1L4WRCwHEG9\n393uNhHVhvLrEcGfrO3iHJc1Q2iw2pVi2xCZd/QxtyWhoJV/lrcGpLIkK0jRIfqs\nLztAVtUP2vGmBl+wYiuzwihgOCjvNSFTC6B2BwyzYCdt+f8UfC5fjsWuQwKBgB8b\n0+o8OJsMC1hUDisVDj0xowBjbSkO+7QxtnN5NM8iY+mHdqKSzsP3OFLiQgYg9aF7\nok3GujEyMyvPqIRi402ZJu2lkgm801Dtfa4o3Rvq5Fgfj9kjuzxonCxVqKVEcFtL\nOq+qMPE+WeQN6kRp6rogp80ecO+OAPnWzhWAEUgJAoGBAN5M3pMst12c2ubgFYQG\nDTccudz3j9h8OCTnakRm6A97VIuaXu1Ua/9vSdQNJc/afvmgwT0YCYE3LIqtr/Tj\nZr40PhJNa5j02AN3M0P0F/U/nwo5+q9fRq372gJmtmoTXR4dJ0yMgURTxdVcRP4w\nyaF5KItH6jB+jUg2XWMjjT9A\n-----END PRIVATE KEY-----\n",
		"client_email": "firebase-adminsdk-tzvgx@location-based-file-sharing.iam.gserviceaccount.com",
		"client_id": "109255393444229050659",
		"auth_uri": "https://accounts.google.com/o/oauth2/auth",
		"token_uri": "https://oauth2.googleapis.com/token",
		"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
		"client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-tzvgx%40location-based-file-sharing.iam.gserviceaccount.com"
	  }
	  `))
	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		log.Fatalf("error initializing app: %v", err)
	}

	// Get a Firestore client
	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalf("error getting Firestore client: %v", err)
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
		// Start the HTTP server to create a user
		http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			// Decode the request body into a User struct
			user := create_user.User{
				Name:  "Jalil Grover",
				Email: "lavdakaemail@keksite.in",
				Age:   69,
			}
			
			// Create the user in Firestore
			err = create_user.CreateUser(ctx, client, user)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			// Write a success message to the response writer
			w.Header().Set("Content-Type", "text/plain")
			fmt.Fprintln(w, "User created successfully")
		})

		fmt.Println("Starting HTTP server to create a user...")
		http.ListenAndServe(fmt.Sprintf(":%s", *port), nil)
	} else {
		fmt.Println("Please specify an operation with the -getfiles or -createuser flag.")
	}
}
