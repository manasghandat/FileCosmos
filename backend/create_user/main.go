package main

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

type User struct {
	Name        string
	Age         int
	EmailAddress string
}

func main() {
	// Initialize the Firebase app
	ctx := context.Background()
	opt := option.WithCredentialsFile("../../backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json")
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

	// Create a new user object
	user := User{
		Name:        "raman",
		Age:         25,
		EmailAddress: "raman@example.com",
	}

	// Add the user to the "users" collection in Firestore
	_, err = client.Collection("users").Doc("raman").Set(ctx, user)
	if err != nil {
		log.Fatalf("error adding user to Firestore: %v", err)
	}

	// Retrieve the user from Firestore
	doc, err := client.Collection("users").Doc("raman").Get(ctx)
	if err != nil {
		log.Fatalf("error getting user from Firestore: %v", err)
	}

	// Print the user's details
	var u User
	err = doc.DataTo(&u)
	if err != nil {
		log.Fatalf("error parsing user data: %v", err)
	}
	fmt.Printf("Name: %s\nAge: %d\nEmailAddress: %s\n", u.Name, u.Age, u.EmailAddress)
}