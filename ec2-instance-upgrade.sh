# Script to upgrade the instance type of an AWS EC2 instance.
# Usage: ./upgrade-ec2.sh <instance-id> <new-instance-type> [region]
# Stops the instance, changes its type, and then restarts it.


#!/usr/bin/env bash

set -e

INSTANCE_ID=$1
NEW_INSTANCE_TYPE=$2
REGION=${3:-us-east-1}

echo "$INSTANCE_ID, $NEW_INSTANCE_TYPE, $REGION"

if [[ -z "$INSTANCE_ID" || -z "NEW_INSTANCE_TYPE" ]]; then
    echo "Usage: $0 <instance-id> <new-instance-type> [region]"
    exit 1
fi

echo  "Upgrading EC2 Instance: $INSTANCE_ID to type: $NEW_INSTANCE_TYPE in region: $REGION"

# Step 1: Stop the instance
aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION" > /dev/null
aws ec2 wait instance-stopped --instance-ids "$INSTANCE_ID" --region "$REGION"
echo "instnce stopped."

echo "Modifying instance type..."
aws ec2 modify-instance-attribute --instance-id "$INSTANCE_ID" \
    --instance-type "{\"Value\": \"$NEW_INSTANCE_TYPE\"}" --region "$REGION"

echo "Strating instance..."

aws ec2 start-instances --instance-ids "$INSTANCE_ID" --region "$REGION" > /dev/null
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --region "$REGION" > /dev/null
echo "Instance is now running with type : $NEW_INSTANCE_TYPE"
