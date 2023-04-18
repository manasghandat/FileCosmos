package user

import (
	"context"
	"ooad/models"

	"cloud.google.com/go/firestore"
)

func GetUser(ctx context.Context, client *firestore.Client, name string) (models.User, error) {
	var user models.User

	// Retrieve the user from the "users" collection in Firestore
	doc, err := client.Collection("users").Doc(name).Get(ctx)
	if err != nil {
		return models.User{}, err
	}

	// Unmarshal the document data into a User struct
	if err := doc.DataTo(&user); err != nil {
		return models.User{}, err
	}

	return user, nil
}
