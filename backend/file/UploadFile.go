package file

import (
	"context"
	"io"
	"fmt"
	"time"
	"net/http"
	"cloud.google.com/go/storage"
)

func UploadFile(w http.ResponseWriter, r *http.Request,ctx context.Context, client *storage.Client, filePath string, objectName string)(error){
	bucketName := "location-based-file-sharing.appspot.com"
	bucket := client.Bucket(bucketName)
	
	file, header, err := r.FormFile("file")
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		fmt.Fprint(w, "Failed to retrieve uploaded file")
		return err
	}

	opts := &storage.SignedURLOptions{
		Scheme:  storage.SigningSchemeV4,
		Method:  "GET",
		Expires: time.Now().Add(24*7 * time.Hour),
}

	defer file.Close()

	fileName := header.Filename

	wc := bucket.Object(fileName).NewWriter(ctx)


	if _, err = io.Copy(wc, file); err != nil {
		wc.Close()
		client.Close()
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprint(w, "Failed to upload file to Firebase Cloud Storage")
		return err
	}

	// Close the storage writer to finalize the upload
	if err = wc.Close(); err != nil {
		client.Close()
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprint(w, "Failed to close storage writer")
		return err
	}

	// Close the Firebase Cloud Storage client
		u, err := bucket.SignedURL(fileName, opts)
	if err != nil {
			return err
	}
	client.Close()
	

	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "text/plain")
	fmt.Fprint(w, u)
	fmt.Printf("Download URL: %s\n", u)

	return nil
}