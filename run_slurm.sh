#!/bin/bash

# Parse input arguments
PROJ_DIR=$1
IMAGE_FILE=$2

# Container paths
REMOTE_HOME="/home/rstudio"
REMOTE_DIR="$REMOTE_HOME/proj"

# Knit the document
singularity exec \
    --bind "$PROJ_DIR":"$REMOTE_DIR" \
    --cleanenv \
    --home "$REMOTE_HOME" \
    --no-home \
    --pwd "$REMOTE_DIR" \
    "$IMAGE_FILE" \
    Rscript -e "rmarkdown::render(input = 'analysis/manuscript.Rmd')"
