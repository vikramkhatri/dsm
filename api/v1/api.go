package main

import (
	"encoding/json"
	"log"
	"net/http"
)

var port = "18080"

func GetHealthinessStatus(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("{'heathStatus':'OK'}")
	// w.Write([]byte ("Node Health OK "))
	// w.WriteHeader(http.StatusOK)
}
func GetLivelinessStatus(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("{'isUP':'true'}")
}
func GetDBName(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("{'name':'TestDB'}")
}
func GetInstanceName(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("{'name':'Testinstance'}")
}

func GetNodes(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("{'nodes':['node1', 'node2']}")
}

func main() {
	http.HandleFunc("/v1/healthiness", GetHealthinessStatus)
	http.HandleFunc("/v1/liveliness", GetLivelinessStatus)
	http.HandleFunc("/v1/db-name", GetDBName)
	http.HandleFunc("/v1/instance-name", GetInstanceName)
	http.HandleFunc("/v1/nodes", GetNodes)
	log.Println("listening on ", port)
	err := http.ListenAndServe("0.0.0.0:"+port, nil)
	log.Println("Error while starting server", err)

}
