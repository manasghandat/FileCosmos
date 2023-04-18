package file

import (
	"context"
	"io/ioutil"
	"ooad/models"

	"cloud.google.com/go/storage"
)

func GetFile(ctx context.Context,client *storage.Client,objectName string) (*models.File, error) {

	// Get the file from Google Cloud Storage
	bucketName := "location-based-file-sharing.appspot.com"
	bucket := client.Bucket(bucketName)
	object := bucket.Object(objectName)
	reader, err := object.NewReader(ctx)
	if err != nil {
		return nil, err
	}
	defer reader.Close()

	// Read the file data into a byte slice
	data, err := ioutil.ReadAll(reader)
	if err != nil {
		return nil, err
	}

	// Create a File struct with the file name and data
	file := &models.File{
		Name: objectName,
		Data: data,
	}

	return file, nil
}