#!/bin/bash

# Builds the docker image that runs the tests.
sudo docker build --tag srbackup:latest .

# Removes built image.
sudo docker rmi srbackup:latest

exit 0