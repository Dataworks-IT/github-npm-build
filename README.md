This was originally created by Ezequiel Leites <ezequiel@leites.dev> under https://github.com/leiteszeke/github-react-build
I only modified it so that it uses npm to build the app and refer to the main branch instead of master.

I usually combine it in a Github action that then publishes the result of the build to S3.

Here's an example : 

```
name: Publish app to S3 Bucket

on: 
  push:
    branches:
      - main

jobs:
  build:
    name: Build and Deploy
    runs-on: ubuntu-latest

    steps:
      - name: Build React App
        uses: erikrob/github-npm-build@main
        env:
          ACCESS_TOKEN: ${{ secrets.ACCESS_TOKEN }}
          DISABLE_ESLINT_PLUGIN: true
          #BUILD_SCRIPT: npm install && npm build
      - name: Deploy to S3 Bucket
        run: aws s3 sync build/ s3://DEST_BUCKET --acl public-read
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: us-west-2

# ACCESS_TOKEN is your personal Github Access Token in order to clone private repositories. (to be setup in your Github Secrets)
# AWS_ACCESS_KEY_ID is your IAM Access Key  (to be setup in your Github Secrets)
# AWS_SECRET_ACCESS_KEY is yout IAM Secret Key  (to be setup in your Github Secrets)
# build/ is the folder to sync to S3
# replace DEST_BUCKET with your bucket name.
```
