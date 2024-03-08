package controller

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strconv"

	"github.com/mayejacob/go-pexels/model"
)

func (c *Client) SearchPhotos(query string, perPage, page int) (*model.SearchResult, error) {
	url := fmt.Sprintf(model.PhotoApi+"/search?query=%s&per_page=%d&page=%d", query, perPage, page)
	resp, err := c.requestDoWithAuth("GET", url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	var result model.SearchResult
	err = json.Unmarshal(data, &result)
	return &result, err
}

func SearchPhotosHandler(w http.ResponseWriter, r *http.Request) {
	// Initialize your client
	TOKEN := os.Getenv("PEXELS_TOKEN")
	client := NewClient(TOKEN)

	query := r.URL.Query().Get("query")
	perPageStr := r.URL.Query().Get("per_page")
	pageStr := r.URL.Query().Get("page")

	perPage, err := strconv.Atoi(perPageStr)
	if err != nil {
		perPage = 15 // Default perPage value if not provided or invalid
	}

	page, err := strconv.Atoi(pageStr)
	if err != nil {
		page = 1 // Default page value if not provided or invalid
	}

	// Use the client to search photos
	result, err := SearchPhotos(query, perPage, page)
	if err != nil {
		http.Error(w, "Search Error: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// Marshal the result into JSON
	responseBody, err := json.MarshalIndent(result, "", "  ")
	if err != nil {
		http.Error(w, "Error marshaling response: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// Set headers and write response
	w.Header().Set("Content-Type", "application/json")
	w.Write(responseBody)
}

func (c *Client) requestDoWithAuth(method, url string) (*http.Response, error) {
	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Add("Authorization", c.Token)
	resp, err := c.hc.Do(req)
	if err != nil {
		return resp, err
	}
	times, err := strconv.Atoi(resp.Header.Get("X-RateLimit-Remaining"))
	if err != nil {
		return resp, nil
	} else {
		c.RemainingTimes = int32(times)
	}
	return resp, nil
}
