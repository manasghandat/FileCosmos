package user

import (
	"ooad/models"
	"context"

	"cloud.google.com/go/firestore"
)



func CreateUser(ctx context.Context, client *firestore.Client, user models.User) error {
	// Add the user to the "users" collection in Firestore
	_, err := client.Collection("users").Doc(user.Name).Set(ctx, user)
	if err != nil {
		return err
	}

	return nil
}

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
