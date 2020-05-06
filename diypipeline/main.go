package main

import (
	"log"
	"net/http"
)

func main() {

defaultPort := "3000"
		log.Println("no env var set for port, defaulting to " + defaultPort)
		// serve the contents of the static folder on '/'
		http.Handle("/", http.FileServer(http.Dir("./static")))
		http.ListenAndServe(":"+defaultPort, nil)

}