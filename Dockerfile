FROM --platform=${BUILDPLATFORM} node:18.18.2-bullseye as node-builder
WORKDIR /build
COPY elune/package.json .

RUN yarn config set registry 'https://registry.npm.taobao.org' && \
    yarn install

COPY elune .

RUN yarn build

FROM golang:1.21.5-alpine3.18 as go-builder
WORKDIR /build
RUN apk add make git && \
    go env -w GOPROXY=https://goproxy.cn,direct

COPY elune-backend/go.mod elune-backend/go.sum ./
RUN go mod download

COPY elune-backend .
COPY --from=node-builder /build/dist pkg/server/static
RUN make build

FROM nginx:stable-alpine

COPY default.conf /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY --from=node-builder /build/dist /usr/share/nginx/html
COPY --from=go-builder /build/bin /app
COPY entrypoint /docker-entrypoint.d

COPY elune-backend/config /app/config
EXPOSE 80 443
