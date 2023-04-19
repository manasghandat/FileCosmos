package file

import (
	"context"
	"math"
	"fmt"
	"ooad/models"
	"strconv"
	"strings"
	"google.golang.org/api/iterator"
	"cloud.google.com/go/firestore"
)

func GetFile(ctx context.Context,cord string,client *firestore.Client) ([]models.File, error) {

	// Get the file from Google Cloud Storage
	files := client.Collection("files").Documents(ctx)

	var listFile []models.File


	//split cord by ,
	fmt.Println(cord)
	location := strings.Split(cord, ",")
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
				latlong := strings.Split(fil.Latlong, ",")
		
		l1,err1 := strconv.ParseFloat(latlong[0],64)
		if err1 != nil {
			fmt.Println(err1)
		}

		la1,err2 := strconv.ParseFloat(location[0],64)
		if err2 != nil {
			fmt.Println(err2)
		}

		l2,err3 := strconv.ParseFloat(latlong[1],64)
		if err3 != nil {
			fmt.Println(err3)
		}
		la2,err4 := strconv.ParseFloat(location[1],64)
		if err4 != nil {
			fmt.Println(err4)
		}

		if distance(l1,l2,la1,la2) <= 100 {

			listFile = append(listFile, fil)
		}

}
return listFile,nil
}




func distance(lat1, lon1, lat2, lon2 float64) float64 {
	// Earth's radius in meters
	R := 6371000.0

	// Convert latitude and longitude from degrees to radians
	lat1Rad := lat1 * (math.Pi / 180.0)
	lon1Rad := lon1 * (math.Pi / 180.0)
	lat2Rad := lat2 * (math.Pi / 180.0)
	lon2Rad := lon2 * (math.Pi / 180.0)

	fmt.Println("lat1 :",lat1, math.Pi/180.0 , lat1*(math.Pi/180.0))
	fmt.Println("lon1 :",lon1, math.Pi/180.0 , lon1*(math.Pi/180.0))
	fmt.Println("lat2 :",lat2, math.Pi/180.0 , lat2*(math.Pi/180.0))
	fmt.Println("lon2 :",lon2, math.Pi/180.0 , lon2*(math.Pi/180.0))


	// Calculate differences in latitude and longitude
	dlat := lat2Rad - lat1Rad
	dlon := lon2Rad - lon1Rad

	fmt.Println(dlat,dlon)
	// Calculate Haversine formula
	a := math.Sin(dlat/2)*math.Sin(dlat/2) + math.Cos(lat1Rad)*math.Cos(lat2Rad)*math.Sin(dlon/2)*math.Sin(dlon/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))
	distance := R * c

	return distance
}

func degToRad(deg float64) float64 {
	return deg * (math.Pi / 180.0)
}


