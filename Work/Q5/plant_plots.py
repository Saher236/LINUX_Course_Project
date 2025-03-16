import argparse
import matplotlib.pyplot as plt  # type: ignore
import os

# Setting the parameters to be received from the terminal
parser = argparse.ArgumentParser(description="Generate plant growth plots.")
parser.add_argument("--plant", type=str, required=True, help="Plant name")
parser.add_argument("--height", type=float, nargs="+", required=True, help="List of plant heights over time (cm)")
parser.add_argument("--leaf_count", type=int, nargs="+", required=True, help="List of leaf counts over time")
parser.add_argument("--dry_weight", type=float, nargs="+", required=True, help="List of dry weights (g)")
args = parser.parse_args()

plant = args.plant
height_data = args.height
leaf_count_data = args.leaf_count
dry_weight_data = args.dry_weight

print(f"Plant: {plant}")
print(f"Height data: {height_data} cm")
print(f"Leaf count data: {leaf_count_data}")
print(f"Dry weight data: {dry_weight_data} g")

# Define output directory
output_dir = "/app/output"
os.makedirs(output_dir, exist_ok=True)

# Create scatter plot
plt.figure(figsize=(10, 6))
plt.scatter(height_data, leaf_count_data, color='b')
plt.title(f'Height vs Leaf Count for {plant}')
plt.xlabel('Height (cm)')
plt.ylabel('Leaf Count')
plt.grid(True)
scatter_path = os.path.join(output_dir, f"{plant}_scatter.png")
plt.savefig(scatter_path)
plt.close()

# Create histogram
plt.figure(figsize=(10, 6))
plt.hist(dry_weight_data, bins=5, color='g', edgecolor='black')
plt.title(f'Histogram of Dry Weight for {plant}')
plt.xlabel('Dry Weight (g)')
plt.ylabel('Frequency')
plt.grid(True)
hist_path = os.path.join(output_dir, f"{plant}_histogram.png")
plt.savefig(hist_path)
plt.close()

# Create line graph
weeks = [f'Week {i+1}' for i in range(len(height_data))]
plt.figure(figsize=(10, 6))
plt.plot(weeks, height_data, marker='o', color='r')
plt.title(f'{plant} Height Over Time')
plt.xlabel('Week')
plt.ylabel('Height (cm)')
plt.grid(True)
line_path = os.path.join(output_dir, f"{plant}_line_plot.png")
plt.savefig(line_path)
plt.close()

print(f"Generated plots for {plant}:")
print(f"Scatter plot saved as {scatter_path}")
print(f"Histogram saved as {hist_path}")
print(f"Line plot saved as {line_path}")