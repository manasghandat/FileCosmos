package file

import (
	"context"
	"io/ioutil"
	"log"

	"cloud.google.com/go/storage"
)

func UploadFile(ctx context.Context, client *storage.Client, filePath string, objectName string)(error){
	bucketName := "location-based-file-sharing.appspot.com"
	bucket := client.Bucket(bucketName)
	
	fileContents, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatalf("error reading file: %v", err)
	}

	wc := bucket.Object(objectName).NewWriter(ctx)
	if _, err = wc.Write(fileContents); err != nil {
		log.Fatalf("error writing file to bucket: %v", err)
	}
	if err := wc.Close(); err != nil {
		log.Fatalf("error closing writer: %v", err)
	}

	return nil
}