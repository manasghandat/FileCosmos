package get_user

import (
	"context"
	"log"
	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

type User struct {
	Name  string `firestore:"name"`
	Age   int    `firestore:"age"`
	Email string `firestore:"email"`
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

func main() {
	ctx := context.Background()
	opt := option.WithCredentialsFile("../../backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json")
	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	// Access Firestore database
	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalf("error initializing firestore client: %v\n", err)
	}
	defer client.Close()

	// Get a reference to the "users" collection
	users := client.Collection("users")

	// Get the document with ID "alice"
	doc, err := users.Doc("alice").Get(ctx)
	if err != nil {
		log.Fatalf("error getting document: %v", err)
	}

	// Deserialize the document data into a User struct
	var user User
	err = doc.DataTo(&user)
	if err != nil {
		log.Fatalf("error deserializing document data: %v", err)
	}

	log.Printf("name: %s, age: %d, email: %s", user.Name, user.Age, user.Email)
}