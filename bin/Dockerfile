FROM golang:1.21.5

WORKDIR /app

COPY . .

RUN go build main.go

CMD ["./main"]

EXPOSE 8887
