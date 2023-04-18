package models

type User struct {
	Name  	string `json:"name"`
	Email 	string `json:"email"`
	ID   	string `json:"id"`
	Ufiles 	[]map[string]string `json:"Ufiles"`
	Dfiles	[]map[string]string `json:"Dfiles"`
}