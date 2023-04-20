FROM golang:1.19
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY file ./file/
COPY models ./models/
COPY user ./user/
COPY main.go ./
COPY *.json ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /main
EXPOSE 8080
CMD ["/main"]