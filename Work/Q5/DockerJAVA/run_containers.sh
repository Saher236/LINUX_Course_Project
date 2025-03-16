#!/bin/bash

PYTHON_IMAGE="plant_plotter"
JAVA_IMAGE="java_watermark"
OUTPUT_DIR="Work/Q5/output"
STUDENT1INFO="Rami AbuJabal 206528085"
STUDENT2INFO="Saher Jammal 209404946"
WATERMARK_TEXT="$STUDENT1INFO & $STUDENT2INFO"

if [[ "$(docker images -q $PYTHON_IMAGE 2> /dev/null)" == "" ]]; then
    echo "Building Python container..."
    docker build -t $PYTHON_IMAGE Work/Q5
fi

echo "Running Python container to generate diagrams..."
docker run --rm -v "$(pwd)/output:/app/output" $PYTHON_IMAGE --plant "Rose" --height 50 55 60 65 70 --leaf_count 35 40 45 50 55 --dry_weight 2.0 2.2 2.5 2.7 3.0

if [[ "$(docker images -q $JAVA_IMAGE 2> /dev/null)" == "" ]]; then
    echo "Building Java container..."
    docker build -t $JAVA_IMAGE Work/Q5/JavaDocker
fi

echo "Running Java container to add watermark..."
docker run --rm -v "$(pwd)/output:/app/output" $JAVA_IMAGE output "$WATERMARK_TEXT"

echo "Cleaning up Docker images and containers..."
docker system prune -af

history > Work/Q5/docker_run_history.log

echo "Process complete. Watermarked images saved in $OUTPUT_DIR"
