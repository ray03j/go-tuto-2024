ARG GO_VERSION=1.22.1
ARG ALPINE_VERSION=3.18

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}
WORKDIR /go/src/go-backend

RUN apk update && apk add git
RUN go install github.com/cosmtrek/air@latest

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
CMD ["air", "-c", ".air.toml"]