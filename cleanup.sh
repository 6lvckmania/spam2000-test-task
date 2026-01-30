#!/bin/bash

PROFILE=${MINIKUBE_PROFILE:-spam2000-test-task}

echo "This will delete the Minikube cluster: $PROFILE"
read -p "Continue? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
  echo "Cancelled"
  exit 0
fi

echo "Deleting cluster..."
minikube delete -p "$PROFILE"
echo "Done"
