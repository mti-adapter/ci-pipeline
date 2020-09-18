FROM nginx:1.15
#Copy ci-dashboard-dist
COPY /app/dist/out/ /usr/share/nginx/html
#Copy default nginx configuration
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf
