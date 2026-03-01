FROM hshar/webapp
ADD ./index.html /var/www/html
CMD ["apache2ctl", "-D", "FOREGROUND"]
