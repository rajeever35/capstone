FROM nginx

WORKDIR /usr/share/nginx/html/

RUN rm /usr/share/nginx/html/index.html

COPY html_file/ /usr/share/nginx/html/