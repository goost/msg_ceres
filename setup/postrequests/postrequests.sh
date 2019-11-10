#!/bin/bash

# Add users
for filename in users/*.json; do
    curl -X POST --header "Content-Type: application/json" \
        --data @$filename \
        "$1/users"
done

# Add group
curl -X POST --header "Content-Type: application/json" \
        --data @group.json \
        "$1/groups"

# Add users to group
curl -X POST "$1/groups/1/members/1" -H  "accept: */*"
curl -X POST "$1/groups/1/members/2" -H  "accept: */*"
curl -X POST "$1/groups/1/members/3" -H  "accept: */*"

# Add lunch locations
for filename in lunchLocations/*.json; do
    curl -X POST --header "Content-Type: application/json" \
        --data @$filename \
        "$1/groups/1/lunchLocations"
done

# Add election
curl -X POST --header "Content-Type: application/json" \
        --data @election.json \
        "$1/groups/1/elections"
