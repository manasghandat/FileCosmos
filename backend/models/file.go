package models

type File struct {
	Name string `json:"name"`
	Data []byte `json:"data"`
}