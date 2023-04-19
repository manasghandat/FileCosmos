package models

type File struct {
	ID string `json:"id"`
	Name string `json:"name"`
	Url string `json:"url"`
	Location string `json:"location"`
	Latlong string `json:"latlong"`
}
