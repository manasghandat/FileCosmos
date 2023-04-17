package upload_file
import (
	"context"
	"fmt"
	"log"
	"io/ioutil"
	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
)

func UploadFile(bucketName, objectName string, data []byte) error {
	// Initialize a Google Cloud Storage client
	ctx := context.Background()
	client, err := storage.NewClient(ctx, option.WithCredentialsFile("../backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json"))
	if err != nil {
		return err
	}

	// Get the bucket
	bucket := client.Bucket(bucketName)

	// Create a writer for the object
	object := bucket.Object(objectName)
	writer := object.NewWriter(ctx)

	// Write the file data to the object
	if _, err := writer.Write(data); err != nil {
		return err
	}

	// Close the writer to save the object
	if err := writer.Close(); err != nil {
		return err
	}

	fmt.Printf("File uploaded to server://%s/%s\n", bucketName, objectName)

	return nil
}

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
	filePath := "../ooad/nput.txt"
	fileContents, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatalf("error reading file: %v", err)
	}

	// Upload file to bucket with specified name
	objectName := "nput.txt"
	wc := bucket.Object(objectName).NewWriter(ctx)
	if _, err = wc.Write(fileContents); err != nil {
		log.Fatalf("error writing file to bucket: %v", err)
	}
	if err := wc.Close(); err != nil {
		log.Fatalf("error closing writer: %v", err)
	}

	log.Printf("file %s uploaded to bucket %s", objectName, bucketName)
}