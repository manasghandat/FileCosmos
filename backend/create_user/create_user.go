package create_user

import (
	"context"
	"fmt"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

type User struct {
	Name         string
	Age          int
	Email string
}

func main() {
	// Initialize the Firebase app
	ctx := context.Background()
	opt := option.WithCredentialsFile("/home/abhyuday/Desktop/FileCosmos/backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json")
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
		Name:         "John Doe",
		Age:          30,
		Email: "johndoe@example.com",
	}

	// Add the user to the "users" collection in Firestore
	err = CreateUser(ctx, client, user)
	if err != nil {
		log.Fatalf("error adding user to Firestore: %v", err)
	}

	// Retrieve the user from Firestore
	user, err = GetUser(ctx, client, user.Name)
	if err != nil {
		log.Fatalf("error getting user from Firestore: %v", err)
	}

	// Print the user's details
	fmt.Printf("Name: %s\nAge: %d\nEmailAddress: %s\n", user.Name, user.Age, user.Email)
}

func CreateUser(ctx context.Context, client *firestore.Client, user User) error {
	// Add the user to the "users" collection in Firestore
	_, err := client.Collection("users").Doc(user.Name).Set(ctx, user)
	if err != nil {
		return err
	}

	return nil
}

func GetUser(ctx context.Context, client *firestore.Client, name string) (User, error) {
	var user User

	// Retrieve the user from the "users" collection in Firestore
	doc, err := client.Collection("users").Doc(name).Get(ctx)
	if err != nil {
		return User{}, err
	}

	// Unmarshal the document data into a User struct
	if err := doc.DataTo(&user); err != nil {
		return User{}, err
	}

	return user, nil
}
