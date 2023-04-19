package file

import (
	"context"
	"fmt"
	"ooad/models"
	"google.golang.org/api/iterator"
	"cloud.google.com/go/firestore"
)

func GetAllFiles(ctx context.Context,client *firestore.Client) ([]models.File, error) {

	// Get the file from Google Cloud Storage
	files := client.Collection("files").Documents(ctx)

	var listFile []models.File


	//split cord by ,
	for {
        file, err := files.Next()
        if err == iterator.Done {
                break
        }
        if err != nil {
                return listFile, err
        }
		var fil models.File
		file.DataTo(&fil)
		listFile = append(listFile, fil)

		
	}
	fmt.Println(listFile);
return listFile,nil
}