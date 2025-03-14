#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

CSV_FILE="$1"

if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: File '$CSV_FILE' not found!"
    exit 1
fi

# Create a virtual workspace if it does not exist
VENV_DIR="Work/Q4/venv"
if [[ ! -d "$VENV_DIR" ]]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"
pip install -r Work/Q2/requirements.txt

while IFS=, read -r plant height leaf_count dry_weight; do
    plant=$(echo "$plant" | tr -d '"')
    height=$(echo "$height" | tr -d '"')
    leaf_count=$(echo "$leaf_count" | tr -d '"')
    dry_weight=$(echo "$dry_weight" | tr -d '"')
    if [[ "$plant" != "Plant" ]]; then
        echo "Processing $plant..."
        python3 Work/Q2/plant_plots.py --plant "$plant" --height $height --leaf_count $leaf_count --dry_weight $dry_weight
        
        mkdir -p Work/Q4/Diagrams/$plant
        mv ${plant}_*.png Work/Q4/Diagrams/$plant/
    fi
done < "$CSV_FILE"

LOG_FILE="Work/Q4/process_log.txt"
echo "Processing completed for CSV file: $CSV_FILE" > "$LOG_FILE"
ls -R Work/Q4/Diagrams/ >> "$LOG_FILE"

deactivate

echo "Process complete. Log file saved to $LOG_FILE"
