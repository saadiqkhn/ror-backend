name: GCP Cloud Run Deployment

on:
  push:
    branches:
      - main

jobs:
  deploy:
    name: Deploy to Google Cloud Run
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set up Google Cloud SDK
        uses: google-github-actions/setup-gcloud@v1
        with:
          project_id: ror-deployment-440909
          service_account_key: ${{ secrets.GCP_CREDENTIALS }}
          export_default_credentials: true

      - name: Build Docker Image
        run: docker build -t gcr.io/ror-deployment-440909/ror-backend:$GITHUB_SHA .

      - name: Deploy to Cloud Run
        run: |
          gcloud run deploy ror-backend-service \
            --image gcr.io/ror-deployment-440909/ror-backend:$GITHUB_SHA \
            --platform managed \
            --region us-central1 \
            --allow-unauthenticated

