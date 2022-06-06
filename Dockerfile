FROM debian
WORKDIR /
RUN apt-get update && apt-get install -y rsync
COPY srbackup.sh /
COPY test-suite.sh /
RUN /test-suite.sh