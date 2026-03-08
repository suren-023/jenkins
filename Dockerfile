FROM hshar/webapp

# Copy index.html to Apache web root
ADD ./index.html /var/www/html

# Start Apache in foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
