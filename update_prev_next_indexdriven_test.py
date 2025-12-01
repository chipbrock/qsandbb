import os
import re
from pathlib import Path
import sys

def parse_index_qmd(index_path):
	content = index_path.read_text(encoding="utf-8")
	matches = re.findall(r'\[\s*([^\]]+?)\]\((.*?)\)', content)
	return [(title.strip(), (index_path.parent / rel_path).resolve()) for title, rel_path in matches]

def update_links(category_dir):
	category_path = Path(category_dir).resolve()
	index_path = category_path / "index.qmd"

	if not index_path.exists():
		print("❌ index.qmd not found.")
		return

	post_info = parse_index_qmd(index_path)

	for i, (title, post_path) in enumerate(post_info):
		if not post_path.exists():
			print(f"⚠️ Skipping missing: {post_path}")
			continue

		# Build prev/next links
		prev_link = ""
		next_link = ""

		if i > 0:
			prev_title, prev_path = post_info[i - 1]
			prev_rel = os.path.relpath(prev_path.with_suffix(".html"), post_path.parent)
			prev_link = f"👈 [Previous: {prev_title}]({prev_rel})"

		if i < len(post_info) - 1:
			next_title, next_path = post_info[i + 1]
			next_rel = os.path.relpath(next_path.with_suffix(".html"), post_path.parent)
			next_link = f"[Next: {next_title}]({next_rel}) 👉"

		# Build the nav block
		block = "::: {.post-nav}\n"
		if prev_link:
			block += prev_link
		if prev_link and next_link:
			block += " | "
		if next_link:
			block += next_link
		block += "\n:::"

		# Read the file line-by-line
		lines = post_path.read_text(encoding="utf-8").splitlines()
		new_lines = []
		inserted = {"MARKER1": False, "MARKER2": False}

		for line in lines:
			if line.strip() == "MARKER1":
				new_lines.append(block)
				inserted["MARKER1"] = True
			elif line.strip() == "MARKER2":
				new_lines.append(block)
				inserted["MARKER2"] = True
			else:
				new_lines.append(line)

		if inserted["MARKER1"] or inserted["MARKER2"]:
			post_path.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
			print(f"✅ Updated: {post_path.name}")
		else:
			print(f"⏭️ No MARKERs found: {post_path.name} — left untouched")

if __name__ == "__main__":
	if len(sys.argv) != 2:
		print("Usage: python update_prev_next_with_markers.py <category-directory>")
	else:
		update_links(sys.argv[1])