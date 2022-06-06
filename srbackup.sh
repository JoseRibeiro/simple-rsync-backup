#!/bin/bash

echo Simple rsync backup!

rsync -v -a -U -X -E "$1" "$2"

exit 0