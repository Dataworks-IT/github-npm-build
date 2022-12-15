#!/bin/sh -l

set -e

if [ -z "$ACCESS_TOKEN" ] && [ -z "$GITHUB_TOKEN" ]
then
  echo "You must provide the action with either a Personal Access Token or the GitHub Token secret in order to deploy."
  exit 1
fi

FOLDER=build

# Installs Git
apt-get update && \
apt-get install -y git && \

# Directs the action to the the Github workspace.
cd $GITHUB_WORKSPACE && \
git config --global --add safe.directory /github/workspace && \

# Clone repository
git clone https://${ACCESS_TOKEN:-"x-access-token:$GITHUB_TOKEN"}@github.com/${GITHUB_REPOSITORY}.git . && \

# Checks out selected branch (main by default)
echo "Checkout requested branch.." && \
if [ -z "$BRANCH" ]
then
  eval "git checkout main"
else
  eval "git checkout $BRANCH"
fi  && \

# Install dependencies
echo "Installing dependencies.." && \
if [ -z "$INSTALL_DEV" ]
then
  eval "npm install"
else
  eval "npm install --also=dev --production=false"
fi  && \

# Setup AWS
if [ -n "$AWS_PROFILE" ]
then
  echo "Running build scripts.." && \
  mkdir $HOME/.aws && \
  cat <<EOF >$HOME/.aws/credentials
[$AWS_PROFILE]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF
  cat <<EOF >$HOME/.aws/config
[default]
region = us-west-2
[profile stg]
region = us-west-2
[profile prd]
region = us-west-2
EOF
fi && \

# Builds the project
echo "Running build scripts.." && \

if [ -z "$BUILD_CMD" ]
then
  if [ -z "$BUILD_ENV" ]
  then
    eval "npm run build"
  else
    eval "npm run build:$BUILD_ENV"
  fi
else
  if [ -z "$BUILD_ENV" ]
  then
    eval "npm run $BUILD_CMD"
  else
    eval "npm run $BUILD_CMD:$BUILD_ENV"
  fi
fi
