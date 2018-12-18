FROM "homeassistant/home-assistant:latest"
LABEL maintainer="Peter Foreman <peter@frmn.nl>"

# Install socat
RUN apt-get update && \
    apt-get -y install socat mosquitto-clients mysql-client && \
    apt-get clean
RUN mkdir /runwatch

# Run
COPY runwatch/* /runwatch/
CMD [ "bash","/runwatch/run.sh" ]