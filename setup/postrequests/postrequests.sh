#!/bin/bash

# Add users
for filename in users/*.json; do
    curl -X POST --header "Content-Type: application/json" \
        --data @$filename \
        "$1"
done
