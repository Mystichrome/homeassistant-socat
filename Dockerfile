FROM homeassistant/home-assistant:latest
LABEL maintainer="Kevin Blakley"

# Install socat
RUN apk update && \
  apk add socat

#Create runwatch folder
RUN mkdir /runwatch

# Run
COPY runwatch/* /runwatch/
CMD [ "bash","/runwatch/run.sh" ]
