#!/bin/bash
##############
#
#Authr: Moaz Shaban
#Date: 07.02.2025
#Des: Geting all users for any Github repository
#
###############

# Check if the GITHUB_TOKEN environment variable is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN is not set. Please set it before running the script."
    exit 1
fi

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi

# Assign input arguments to variables
REPO_OWNER=$1
REPO_NAME=$2

# GitHub API URL to get repository collaborators
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/collaborators"

# Fetch the list of collaborators
response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "$API_URL")

# Check for errors
if echo "$response" | grep -q "API rate limit exceeded"; then
    echo "Error: API rate limit exceeded. Try again later."
    exit 1
elif echo "$response" | grep -q "Not Found"; then
    echo "Error: Repository not found or access denied."
    exit 1
elif echo "$response" | grep -q "Bad credentials"; then
    echo "Error: Invalid GitHub token. Please check your token."
    exit 1
fi

# Extract and print collaborator usernames using jq
echo "Users with access to the repository '$REPO_NAME':"
echo "$response" | jq -r '.[].login'