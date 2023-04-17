package get_file

import (
	"context"
	"encoding/json"
	"io/ioutil"

	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
)

type File struct {
	Name string `json:"name"`
	Data []byte `json:"data"`
}

func GetFile(bucketName, objectName string) (*File, error) {
	// Initialize a Google Cloud Storage client
	ctx := context.Background()
	client, err := storage.NewClient(ctx, option.WithCredentialsFile("../backend/location-based-file-sharing-firebase-adminsdk-tzvgx-fb430b4173.json"))
	if err != nil {
		return nil, err
	}

	// Get the file from Google Cloud Storage
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
	file := &File{
		Name: objectName,
		Data: data,
	}

	return file, nil
}

func main() {
	// Example usage
	file, err := GetFile("location-based-file-sharing.appspot.com", "Prog.txt")
	if err != nil {
		panic(err)
	}

	// Convert the file struct to JSON and print it to the console
	data, err := json.Marshal(file)
	if err != nil {
		panic(err)
	}
	println(string(data))
}
