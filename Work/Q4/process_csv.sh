#!/bin/bash

CSV_FILE=""
VENV_DIR="Work/Q4/venv"
OUTPUT_DIR="Work/Q4/Diagrams"

usage() {
    echo "Usage: $0 -p <csv_path> [-o <output_dir>] [-v <venv_path>]"
    echo "  -p, --path       Path to the CSV file (required)"
    echo "  -o, --output     Output directory for diagrams (default: Work/Q4/Diagrams)"
    echo "  -v, --venv       Virtual environment directory (default: Work/Q4/venv)"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--path)
            CSV_FILE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -v|--venv)
            VENV_DIR="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

if [[ -z "$CSV_FILE" ]]; then
    echo "Error: CSV file path is required!"
    usage
fi

if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: File '$CSV_FILE' not found!"
    exit 1
fi

if [[ ! -d "$VENV_DIR" ]]; then
    echo "Creating virtual environment at $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"
pip install -r Work/Q2/requirements.txt

mkdir -p "$OUTPUT_DIR"

while IFS=, read -r plant height leaf_count dry_weight; do
    plant=$(echo "$plant" | tr -d '"')
    height=$(echo "$height" | tr -d '"')
    leaf_count=$(echo "$leaf_count" | tr -d '"')
    dry_weight=$(echo "$dry_weight" | tr -d '"')
    if [[ "$plant" != "Plant" ]]; then
        echo "Processing $plant..."
        python3 Work/Q2/plant_plots.py --plant "$plant" --height $height --leaf_count $leaf_count --dry_weight $dry_weight
        
        mkdir -p "$OUTPUT_DIR/$plant"
        mv ${plant}_*.png "$OUTPUT_DIR/$plant/"
    fi
done < "$CSV_FILE"

LOG_FILE="$OUTPUT_DIR/process_log.txt"
echo "Processing completed for CSV file: $CSV_FILE" > "$LOG_FILE"
ls -R "$OUTPUT_DIR" >> "$LOG_FILE"

deactivate

echo "Process complete. Log file saved to $LOG_FILE"
