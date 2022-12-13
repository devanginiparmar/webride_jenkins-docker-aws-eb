#!/bin/bash

# usage: ./deployme.sh staging sddffafaafaf
# license: public domain

application_name="Test"
environment_name="Test-env"

EB_BUCKET=elastic-s3

VERSION="v11"
ZIP="code.$VERSION.zip"

aws configure set default.region us-east-1

# Zip up the Dockerrun file
zip -r $ZIP Dockerrun.aws.json

echo "Copying new zip to S3"
aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
echo "Creating new application version"
aws elasticbeanstalk create-application-version --application-name $application_name \
    --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

# Update the environment to use the new application version
echo "Updating environment"
aws elasticbeanstalk update-environment --environment-name $environment_name \
      --version-label $VERSION
