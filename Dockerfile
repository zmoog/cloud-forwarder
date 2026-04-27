FROM golang:1.26-bookworm AS builder

WORKDIR /build

COPY collector/go.mod collector/go.sum ./collector/
RUN cd collector && go mod download

COPY collector/ ./collector/
COPY config.yaml ./

RUN cd collector && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o /build/collector .

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /build/collector /collector
COPY --from=builder /build/config.yaml /etc/otelcol/config.yaml

USER nonroot:nonroot
ENTRYPOINT ["/collector"]
CMD ["--config", "/etc/otelcol/config.yaml"]
