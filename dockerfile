# Use an official Debian runtime as a parent image
FROM debian:latest

# Update the package repository and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    nginx \
    ssh \
    tor

# # Create a new user and group
RUN useradd -ms /bin/bash -d /home/jcueto-r -G sudo jcueto-r
RUN echo 'jcueto-r:password' | chpasswd
# # Grant sudo access to the new user
# RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/user


RUN tor --runasdaemon 1

# Almacenar archivos de configuración
COPY index.nginx-debian.html /var/www/html/
COPY nginx.conf /etc/nginx/
COPY torrc  /etc/tor/
COPY reloj-imagen-animada-0141.gif /var/www/html/
COPY sshd_config /etc/ssh/
COPY script_init.sh /

RUN chmod 755 /script_init.sh

# USER jcueto-r

# SSH
RUN mkdir /home/jcueto-r/.ssh
COPY authorized_keys /home/jcueto-r/.ssh/authorized_keys
# RUN chmod 700 /home/jcueto-r/.ssh
# RUN chown jcueto-r /home/jcueto-r/.ssh

# Expose ports
EXPOSE 80 4242

# Start Nginx, OpenSSH and Tor services

ENTRYPOINT /script_init.sh


