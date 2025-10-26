import re
from pathlib import Path

def sort_index_blocks(category_dir):
	index_path = Path(category_dir) / "index.qmd"

	if not index_path.exists():
		print(f"❌ No index.qmd found in {category_dir}")
		return

	lines = index_path.read_text(encoding="utf-8").splitlines()

	try:
		posts_start = lines.index("## Posts")
	except ValueError:
		print("❌ Could not find '## Posts' section in the file.")
		return

	header = lines[:posts_start + 1]
	rest = lines[posts_start + 1:]

	# Collect blocks ending in a link line
	blocks = []
	current_block = []
	for line in rest:
		if re.match(r"^\s*- \[\d+\..*\]\(.*\)", line):
			current_block.append(line)
			blocks.append(current_block)
			current_block = []
		else:
			if line.strip() == "" and not current_block:
				continue  # skip leading blank lines
			current_block.append(line)

	def sort_key(block):
		for line in reversed(block):
			match = re.match(r"- \[(\d+)\.", line.strip())
			if match:
				return int(match.group(1))
		return float("inf")

	sorted_blocks = sorted(blocks, key=sort_key)
	new_content = "\n".join(header + [""] + ["\n".join(block) for block in sorted_blocks]) + "\n"
	index_path.write_text(new_content, encoding="utf-8")
	print(f"✅ Sorted blocks: {index_path}")

if __name__ == "__main__":
	directory = input("📁 Enter directory (e.g., particle-bios): ").strip()
	sort_index_blocks(directory)
