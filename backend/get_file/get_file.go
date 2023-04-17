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
	client, err := storage.NewClient(ctx, option.WithCredentialsJSON([]byte(`{
		"type": "service_account",
		"project_id": "location-based-file-sharing",
		"private_key_id": "fb430b4173f26c315476891a34b759457f18dd08",
		"private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC07msR8IuWeeNA\nlGq0Ynl2nGfYx/eceMRJ2efqP6iDY0dfoyiwrTrs1Xhm1883AIWNqlTeA0ehfmfr\nqQo+09OPTUpWR7WOIDSlMELiRhXnLaxVolANxx3ZJrceTOiyf7sCKHmp9IgfCybN\nml82iiSz8N7FvxtOVekjKU/6/5IkziOaulaqVsjNGSd6oWuHo/K73g7aPH+qlD+f\nuLe0sEeywXeHaCenA15VXQ6nLyk8lkJNgGoNHLz0gPrHhyh25UkUnbNgo/OOfChn\nanp2WRxaqUEnYeuRw0Bm3k7mAro8T77vAv6MOzAMl7ubukp+XJRcEmqsJs3lmC1D\nU4HdfrRDAgMBAAECggEAAIGwZA733RZ/R+WCfPnPnEDo24cHzvTZm9lT2GiQOLn0\n77Qdv4zkntgkK6mMB3vlY9Wnwi1hLHcVpGfHQxDFxV9yh1ZREFJPw2ykq0yF8C1F\nD8JSFg/KKhr9JUUS27kW1XU2jf7EyM13sNivTpBJdQWGIiicU3ZTHkmV0z6W8qpt\n4frCGqlawPexsilh1/MieSzvNcxcWCYPrTBk9i2QkdIru6Z9J5Rkis/SI5XHUgsC\n7DSsFNeqHA+75pkpJ5FCc8a49Ip4p9bqVFZ4JgkbqqaiA+u+fIjqK7UqWQEPNteK\nwd0w7FhtavqhgClg+VGYt+b1b8pfsk8sSawYTuGJWQKBgQDuHZz6LGzBm0K+BJD7\nYIYq83BjX7el7L6afayrRaHHQ3fpP4ZzIZuTLawaspuvhCVa78eil8iJXJzsDaM8\nCNZiQbhGMjqX4llHmsbIVo0vRXTKT+DMzC/2SDkgP3huZ4gX53fgS/OthwihKGVL\nfN0RSXNLYZFiTepYmYmc/6xLawKBgQDChUnjOwHc5HuArnTgsULblD2y07TISixi\nhE1oaL3wM6kLZCvq1Y6vqlLaRwBst0fL29h3OEyYbCndbyq4fji6IXmuYiHvHm9f\nZmFyo/j8EUylgKWFnqaIum1NGykITn5FgP0dgKl/Khy7356/QOBrW53zshXJgYoe\n0bZj2o0IiQKBgQDAwe46w03DKOnNoyqupEPYbzty5qBnTJA7xjLKb1L4WRCwHEG9\n393uNhHVhvLrEcGfrO3iHJc1Q2iw2pVi2xCZd/QxtyWhoJV/lrcGpLIkK0jRIfqs\nLztAVtUP2vGmBl+wYiuzwihgOCjvNSFTC6B2BwyzYCdt+f8UfC5fjsWuQwKBgB8b\n0+o8OJsMC1hUDisVDj0xowBjbSkO+7QxtnN5NM8iY+mHdqKSzsP3OFLiQgYg9aF7\nok3GujEyMyvPqIRi402ZJu2lkgm801Dtfa4o3Rvq5Fgfj9kjuzxonCxVqKVEcFtL\nOq+qMPE+WeQN6kRp6rogp80ecO+OAPnWzhWAEUgJAoGBAN5M3pMst12c2ubgFYQG\nDTccudz3j9h8OCTnakRm6A97VIuaXu1Ua/9vSdQNJc/afvmgwT0YCYE3LIqtr/Tj\nZr40PhJNa5j02AN3M0P0F/U/nwo5+q9fRq372gJmtmoTXR4dJ0yMgURTxdVcRP4w\nyaF5KItH6jB+jUg2XWMjjT9A\n-----END PRIVATE KEY-----\n",
		"client_email": "firebase-adminsdk-tzvgx@location-based-file-sharing.iam.gserviceaccount.com",
		"client_id": "109255393444229050659",
		"auth_uri": "https://accounts.google.com/o/oauth2/auth",
		"token_uri": "https://oauth2.googleapis.com/token",
		"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
		"client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-tzvgx%40location-based-file-sharing.iam.gserviceaccount.com"
	  }
	  `)))
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
