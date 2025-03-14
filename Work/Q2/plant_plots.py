import argparse
import matplotlib.pyplot as plt

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

#Create Graph
plt.figure(figsize=(10, 6))
plt.scatter(height_data, leaf_count_data, color='b')
plt.title(f'Height vs Leaf Count for {plant}')
plt.xlabel('Height (cm)')
plt.ylabel('Leaf Count')
plt.grid(True)
plt.savefig(f"{plant}_scatter.png")
plt.close()

#Create History Graph
plt.figure(figsize=(10, 6))
plt.hist(dry_weight_data, bins=5, color='g', edgecolor='black')
plt.title(f'Histogram of Dry Weight for {plant}')
plt.xlabel('Dry Weight (g)')
plt.ylabel('Frequency')
plt.grid(True)
plt.savefig(f"{plant}_histogram.png")
plt.close()

#Creating a line graph
weeks = [f'Week {i+1}' for i in range(len(height_data))]
plt.figure(figsize=(10, 6))
plt.plot(weeks, height_data, marker='o', color='r')
plt.title(f'{plant} Height Over Time')
plt.xlabel('Week')
plt.ylabel('Height (cm)')
plt.grid(True)
plt.savefig(f"{plant}_line_plot.png")
plt.close()

print(f"Generated plots for {plant}:")
print(f"Scatter plot saved as {plant}_scatter.png")
print(f"Histogram saved as {plant}_histogram.png")
print(f"Line plot saved as {plant}_line_plot.png")
