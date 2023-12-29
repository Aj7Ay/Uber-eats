# Use a lightweight web server as the base image
FROM nginx:alpine

# Copy the HTML, CSS, JavaScript, and Assets into the default web server directory
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/
COPY --chown=nginx:nginx Fonts /usr/share/nginx/html/Fonts
COPY --chown=nginx:nginx Assets /usr/share/nginx/html/Assets

# Expose port 80 for serving the web application
EXPOSE 80

# Define the default command to start the web server
CMD ["nginx", "-g", "daemon off;"]

