#!/bin/bash

# Bright Foreground Colors
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

# Displaying start message

# Instruction 1: Setting the Region
echo
echo "${GREEN_TEXT}Enter REGION: ${RESET_FORMAT}"
read -r REGION

export REGION=$REGION

echo "${BLUE_TEXT}${BOLD_TEXT}Region set to: $REGION${RESET_FORMAT}"
echo

gcloud services enable dataplex.googleapis.com

export PROJECT_ID=$(gcloud config get-value project)
echo

gcloud config set compute/region $REGION
echo
gcloud dataplex lakes create ecommerce \
   --location=$REGION \
   --display-name="Ecommerce" \
   --description="Ecommerce Domain"


gcloud dataplex zones create orders-curated-zone \
    --location=$REGION \
    --lake=ecommerce \
    --display-name="Orders Curated Zone" \
    --resource-location-type=SINGLE_REGION \
    --type=CURATED \
    --discovery-enabled \
    --discovery-schedule="0 * * * *"


bq mk --location=$REGION --dataset orders 


gcloud dataplex assets create orders-curated-dataset \
--location=$REGION \
--lake=ecommerce \
--zone=orders-curated-zone \
--display-name="Orders Curated Dataset" \
--resource-type=BIGQUERY_DATASET \
--resource-name=projects/$PROJECT_ID/datasets/orders \
--discovery-enabled 


gcloud dataplex assets delete orders-curated-dataset --location=$REGION --zone=orders-curated-zone --lake=ecommerce --quiet


gcloud dataplex zones delete orders-curated-zone --location=$REGION --lake=ecommerce --quiet


gcloud dataplex lakes delete ecommerce --location=$REGION --quiet


echo
echo -e "${RED_TEXT}${BOLD_TEXT}Subscribe my YouTube Channel:${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@qwiklabexplorers${RESET_FORMAT}"
echo
