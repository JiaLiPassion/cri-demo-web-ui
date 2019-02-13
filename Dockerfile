# Usage:
#
#    Build image:
#    docker build -t cri-demo .
#
#    Run image (on localhost:8080):
#    docker run --name cri-demo -p 8081:80 cri-demo
#
#    Run image as virtual host (read more: https://github.com/jwilder/nginx-proxy):
#    docker run -e VIRTUAL_HOST=cri-demo.your-domain.com --name cri-demo cri-demo

# Stage 1, based on Node.js, to build and compile Angular
FROM node:8.9.4-alpine
COPY package.json ./
COPY yarn.lock ./
## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN npm install -g yarn && \
  yarn && \
  mkdir /ng-app && \
  mv ./node_modules ./ng-app
WORKDIR /ng-app
COPY . .
RUN ./node_modules/.bin/ng build --prod --aot --named-chunks --common-chunk

# Stage 2, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.13.9-alpine
COPY ./config/nginx-custom.conf /etc/nginx/conf.d/default.conf
## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*
## From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=0 /ng-app/dist/cri-demo /usr/share/nginx/html
## Set environment variable from build arg
CMD ["nginx", "-g", "daemon off;"]
