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

