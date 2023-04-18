package file

import (
	"context"
	"io/ioutil"
	"log"
	
	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
)

func main() {
	ctx := context.Background()

	opt := option.WithCredentialsFile("../../backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json")

	// Access Cloud Storage
	client, err := storage.NewClient(ctx, opt)
	if err != nil {
		log.Fatalf("error initializing cloud storage client: %v", err)
	}
	defer client.Close()

	// Get a reference to the default bucket
	bucketName := "location-based-file-sharing.appspot.com"
	bucket := client.Bucket(bucketName)

	// Read file contents
	filePath := "/home/abhyuday/Desktop/ooad/Input.txt"
	fileContents, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatalf("error reading file: %v", err)
	}

	// Upload file to bucket with specified name
	objectName := "Input.txt"
	wc := bucket.Object(objectName).NewWriter(ctx)
	if _, err = wc.Write(fileContents); err != nil {
		log.Fatalf("error writing file to bucket: %v", err)
	}
	if err := wc.Close(); err != nil {
		log.Fatalf("error closing writer: %v", err)
	}

	log.Printf("file %s uploaded to bucket %s", objectName, bucketName)
}