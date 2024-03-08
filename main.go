package main

import (
	"log"
	"net/http"

	"os"

	"github.com/gorilla/mux"
	"github.com/joho/godotenv"

	"github.com/mayejacob/go-pexels/routes"
)

func main() {

	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file:", err)
	}
	TOKEN := os.Getenv("PEXELS_TOKEN")
	if TOKEN == "" {
		log.Fatal("PEXELS_TOKEN is not set in the environment")
	}
	// var c = controller.NewClient(TOKEN)

	var router = mux.NewRouter()
	routes.PixelRoutes(router)
	http.Handle("/", router)
	log.Fatal(http.ListenAndServe(":9090", router))
	// result, err := c.SearchPhotos("waves", 15, 1)
	// if err != nil {
	// 	log.Fatal("Search Error:", err)
	// }
	// if result.Page == 0 {
	// 	log.Println("No Results")
	// 	// Print API response body for debugging
	// 	responseBody, err := json.MarshalIndent(result, "", "  ")
	// 	if err != nil {
	// 		log.Println("Error marshaling response:", err)
	// 	} else {
	// 		log.Println("API Response Body:", string(responseBody))
	// 	}
	// }

	// fmt.Println(result)
}
