package main

import (
	"fmt"
	"net"
	"net/http"
)

func main() {
	// マルチプレクサー: リクエストのパスに応じてハンドラーを振り分ける
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "hello world")
	})

	// リスナー: TCP通信の窓口として接続を受け付ける
	listener, err := net.Listen("tcp", ":3003")
	if err != nil {
		panic(err)
	}
	defer listener.Close()

	// サーバー: リスナーから受け取った接続を処理して配信する
	server := &http.Server{
		Handler: mux,
	}

	fmt.Println("Server listening on port 3003")
	server.Serve(listener)
}