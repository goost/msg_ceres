#!/bin/bash

# Add users
for filename in users/*.json; do
    curl -X POST --header "Content-Type: application/json" \
        --data @$filename \
        http://msg-lunchserver8.westeurope.azurecontainer.io:8080/users
done