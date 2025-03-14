#!/bin/bash

CSV_FILE=""

# Check if there are exactly 5 numbers provided
validate_five_numbers() {
    local input=("$@")
    [[ ${#input[@]} -eq 5 ]]
}

create_csv() {
    read -p "Enter the name of the CSV file to use (e.g., plants.csv): " CSV_FILE
    echo "Plant,Height (cm),Leaf Count,Dry Weight (g)" > "$CSV_FILE"
    echo "CSV file '$CSV_FILE' created."
}

choose_csv() {
    read -p "Enter the name of the CSV file to use: " CSV_FILE
    if [[ -f "$CSV_FILE" ]]; then
        echo "Using CSV file: $CSV_FILE"
    else
        echo "File not found. Creating a new CSV file."
        create_csv
    fi
}

show_csv() {
    if [[ -z "$CSV_FILE" || ! -f "$CSV_FILE" ]]; then
        echo "No CSV file selected! Use option 1 or 2 first."
        return
    fi

    if [[ $(wc -l < "$CSV_FILE") -le 1 ]]; then
        echo "No plants found in $CSV_FILE!"
    else
        column -s, -t < "$CSV_FILE"
    fi
}

add_plant() {
    if [[ -z "$CSV_FILE" || ! -f "$CSV_FILE" ]]; then
        echo "No CSV file selected! Use option 1 or 2 first."
        return
    fi

    read -p "Enter plant name: " plant

    read -p "Enter height (int) (cm) (5 numbers space-separated): " -a height
    while ! validate_five_numbers "${height[@]}"; do
        echo "Error: Please enter exactly 5 space-separated numbers."
        read -p "Enter height (int) (cm) (5 numbers space-separated): " -a height
    done

    read -p "Enter leaf count (int) (5 numbers space-separated): " -a leaf_count
    while ! validate_five_numbers "${leaf_count[@]}"; do
        echo "Error: Please enter exactly 5 space-separated numbers."
        read -p "Enter leaf count (int) (5 numbers space-separated): " -a leaf_count
    done

    read -p "Enter dry weight (float) (g) (5 numbers space-separated): " -a dry_weight
    while ! validate_five_numbers "${dry_weight[@]}"; do
        echo "Error: Please enter exactly 5 space-separated numbers."
        read -p "Enter dry weight (float) (g) (5 numbers space-separated): " -a dry_weight
    done

    echo "$plant,${height[*]},${leaf_count[*]},${dry_weight[*]}" >> "$CSV_FILE"
    echo "Added $plant to CSV."
}

generate_diagrams() {
    if [[ -z "$CSV_FILE" || ! -f "$CSV_FILE" ]]; then
        echo "No valid CSV file selected! Use option 1 or 2 first."
        return
    fi

    read -p "Enter plant name for diagrams: " plant
    row=$(grep "^$plant," "$CSV_FILE")
    if [[ -z "$row" ]]; then
         echo "Error: Plant '$plant' not found in '$CSV_FILE'!"
         return
    fi

    IFS=',' read -r plant_name height_data leaf_count_data dry_weight_data <<< "$row"

    PY_SCRIPT="Work/Q2/plant_plots.py"
    if [[ ! -f "$PY_SCRIPT" ]]; then
        echo "Error: Python script '$PY_SCRIPT' not found!"
        return
    fi

    if ! command -v python3 &>/dev/null; then
        echo "Error: 'python3' command not found! Please install Python."
        return
    fi

    python3 "$PY_SCRIPT" --plant "$plant" \
        --height $(echo "$height_data" | tr ',' ' ') \
        --leaf_count $(echo "$leaf_count_data" | tr ',' ' ') \
        --dry_weight $(echo "$dry_weight_data" | tr ',' ' ')
    
    echo "Diagrams generated for '$plant'."
}

update_plant() {
    if [[ -z "$CSV_FILE" || ! -f "$CSV_FILE" ]]; then
        echo "No CSV file selected! Use option 1 or 2 first."
        return
    fi

    read -p "Enter plant name to update: " plant
    row=$(grep "^$plant," "$CSV_FILE")
    if [[ -z "$row" ]]; then
        echo "Error: Plant '$plant' not found in '$CSV_FILE'!"
        return
    fi

    # Extract existing values
    IFS=',' read -r old_plant old_height old_leaf_count old_dry_weight <<< "$row"

    read -p "Enter new height (int) (5 numbers space-separated, Enter to keep current [$old_height]): " -a height
    if [[ ${#height[@]} -eq 0 ]]; then
        read -a height <<< "$old_height"
    fi
    while ! validate_five_numbers "${height[@]}"; do
        echo "Error: Please enter exactly 5 space-separated numbers."
        read -p "Enter new height (int) (5 numbers space-separated): " -a height
    done

    read -p "Enter new leaf count (int) (5 numbers space-separated, Enter to keep current [$old_leaf_count]): " -a leaf_count
    if [[ ${#leaf_count[@]} -eq 0 ]]; then
        read -a leaf_count <<< "$old_leaf_count"
    fi
    while ! validate_five_numbers "${leaf_count[@]}"; do
        echo "Error: Please enter exactly 5 space-separated numbers."
        read -p "Enter new leaf count (5 numbers space-separated): " -a leaf_count
    done

    read -p "Enter new dry weight (float) (g) (5 numbers space-separated, Enter to keep current [$old_dry_weight]): " -a dry_weight
    if [[ ${#dry_weight[@]} -eq 0 ]]; then
        read -a dry_weight <<< "$old_dry_weight"
    fi
    while ! validate_five_numbers "${dry_weight[@]}"; do
        echo "Error: Please enter exactly 5 space-separated numbers."
        read -p "Enter new dry weight (g) (5 numbers space-separated): " -a dry_weight
    done

    new_height="${height[*]}"
    new_leaf="${leaf_count[*]}"
    new_dry_weight="${dry_weight[*]}"

    awk -v p="$plant" -v h="$new_height" -v l="$new_leaf" -v d="$new_dry_weight" \
        'BEGIN {FS=OFS=","} $1==p {$2=h; $3=l; $4=d} 1' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"

    echo "Updated data for $plant."
}

delete_plant() {
    if [[ -z "$CSV_FILE" || ! -f "$CSV_FILE" ]]; then
        echo "No CSV file selected! Use option 1 or 2 first."
        return
    fi

    read -p "Enter plant name to delete: " plant
    awk -v p="$plant" 'BEGIN{FS=OFS=","} $1!=p' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    echo "Deleted $plant from CSV."
}

find_max_leaf() {
    if [[ -z "$CSV_FILE" || ! -f "$CSV_FILE" ]]; then
        echo "No CSV file selected! Use option 1 or 2 first."
        return
    fi

    awk -F, 'NR>1 {sum[$1]+=$3; count[$1]++} END {for (i in sum) if(count[i]>0) print i, sum[i]/count[i]}' "$CSV_FILE" \
    | sort -k2,2nr | head -n 1
}

while true; do
    clear
    echo "=============================="
    echo " Plant Management Menu"
    echo "=============================="
    echo "1) Create a new CSV file"
    echo "2) Choose an existing CSV file"
    echo "3) Show CSV contents"
    echo "4) Add a new plant"
    echo "5) Generate plant diagrams"
    echo "6) Update plant data"
    echo "7) Delete plant"
    echo "8) Find plant with max average leaf count"
    echo "9) Exit"
    echo "=============================="
    read -p "Choose an option: " choice

    case $choice in
        1) create_csv ;;
        2) choose_csv ;;
        3) show_csv ;;
        4) add_plant ;;
        5) generate_diagrams ;;
        6) update_plant ;;
        7) delete_plant ;;
        8) find_max_leaf ;;
        9) echo "Exiting..."; break ;;
        *) echo "Invalid option! Try again." ;;
    esac
    read -p "Press Enter to continue..."
done