FROM nginx:1.15
#Copy ci-dashboard-dist
COPY ./app/ /usr/share/nginx/html
#Copy default nginx configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
