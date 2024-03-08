package routes

import (
	"github.com/gorilla/mux"
	"github.com/mayejacob/go-pexels/controller"
)

var PixelRoutes = func(router *mux.Router) {
	router.HandleFunc("/search/photos", controller.SearchPhotos).Methods("GET")
	// router.HandleFunc("/search/photos", controller.OldSearchPhotosHandler).Methods("GET")
	// router.HandleFunc("/curated/photos", CuratedPhotosHandler).Methods("GET")
	// router.HandleFunc("/videos/search", VideosSearchHandler).Methods("GET")
	// router.HandleFunc("/videos/popular", VideosPopularHandler).Methods("GET")
	// router.HandleFunc("/videos/curated", VideosCuratedHandler).Methods("GET")
	// router.HandleFunc("/videos/trending", VideosTrendingHandler).Methods("GET")
}
