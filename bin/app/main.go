package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8081"
	}
	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	// Catch-all route handler for undefined routes
	http.HandleFunc("/", logRequest(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			w.WriteHeader(http.StatusNotFound)
			renderTemplate(w, "not-found.html")
			return
		}
		renderTemplate(w, "index.html")
	}))

	log.Printf("Server running on http://localhost:%s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal("Server startup error: ", err)
	}
}

// responseWriter - обертка для http.ResponseWriter, позволяющая логировать статус кода
type responseWriter struct {
	http.ResponseWriter
	statusCode int
}

// WriteHeader - переопределение метода WriteHeader для записи статус кода
func (rw *responseWriter) WriteHeader(statusCode int) {
	rw.statusCode = statusCode
	rw.ResponseWriter.WriteHeader(statusCode)
}

func logRequest(handler http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		wrappedWriter := &responseWriter{ResponseWriter: w, statusCode: http.StatusOK}
		handler(wrappedWriter, r)
		log.Printf("%s %s %s %d", r.Method, r.RequestURI, r.RemoteAddr, wrappedWriter.statusCode)
	}
}

func renderTemplate(w http.ResponseWriter, tmpl string) {
	fp := filepath.Join("templates", tmpl)
	t, err := template.ParseFiles(fp)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	err = t.Execute(w, nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
