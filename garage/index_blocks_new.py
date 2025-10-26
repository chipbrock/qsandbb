import re
from pathlib import Path

def parse_numeric_prefix(line):
	# Match either 4-digit year OR decimal-style prefix (e.g. 2.10)
	match = re.search(r"- \[([0-9]+(?:\.[0-9]+)?) ", line)
	if match:
		prefix = match.group(1)
		try:
			return float(prefix)
		except ValueError:
			pass
	return float("inf")

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

	blocks = []
	current_block = []
	for line in rest:
		if re.match(r"^\s*- \[[0-9]+(?:\.[0-9]+)? ", line):
			if current_block:
				blocks.append(current_block)
			current_block = [line]
		else:
			current_block.append(line)
	if current_block:
		blocks.append(current_block)

	sorted_blocks = sorted(blocks, key=lambda b: parse_numeric_prefix(b[0]))
	new_content = "\n".join(header + [""] + ["\n".join(block) for block in sorted_blocks]) + "\n"
	index_path.write_text(new_content, encoding="utf-8")
	print(f"✅ Sorted blocks: {index_path}")

if __name__ == "__main__":
	directory = input("📁 Enter directory (e.g., feynman-diagrams): ").strip()
	sort_index_blocks(directory)