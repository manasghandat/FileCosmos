package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"

	"cloud.google.com/go/storage"
	// firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

func main() {
	// Initialize the Firebase app
	ctx := context.Background()
	// opt := option.WithCredentialsFile("/home/abhyuday/Desktop/ooad/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json")
	// app, err := firebase.NewApp(ctx, nil, opt)
	// if err != nil {
	// 	log.Fatalf("error initializing app: %v", err)
	// }

	// Get a Cloud Storage client
	client, err := storage.NewClient(ctx, option.WithCredentialsFile("../../backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json"))
	if err != nil {
		log.Fatalf("error getting Cloud Storage client: %v", err)
	}
	defer client.Close()

	// Get a reference to the bucket
	bucketName := "location-based-file-sharing.appspot.com"
	bucket := client.Bucket(bucketName)

	// Get a reference to the file
	objectName := "Prog.txt"
	object := bucket.Object(objectName)

	// Download the file's content
	rc, err := object.NewReader(ctx)
	if err != nil {
		log.Fatalf("error reading file: %v", err)
	}
	defer rc.Close()

	fileContents, err := ioutil.ReadAll(rc)
	if err != nil {
		log.Fatalf("error reading file contents: %v", err)
	}

	// Print the file's contents
	fmt.Println(string(fileContents))
}
