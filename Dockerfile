# Stage 1 - the build process
FROM node:10 as build-deps 
RUN mkdir -p /var/www/html
WORKDIR /var/www/html 
COPY package.json package.json
RUN npm install 
COPY . . 
RUN npm install -g react-scripts
#RUN npm install -g serve

RUN npm run build

# Stage 2 - the production environment
FROM nginx:1.13.9-alpine
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx 
COPY --from=build-deps /var/www/html/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]