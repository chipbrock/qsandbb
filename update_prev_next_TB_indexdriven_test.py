import re
from pathlib import Path
import sys

# Get the category directory from command-line argument
category = sys.argv[1]
index_path = Path(category) / "index.qmd"

# Confirm index file exists
if not index_path.exists():
	print(f"❌ index.qmd not found in: {index_path}")
	sys.exit(1)

# Parse index.qmd to find post titles and paths
index_text = index_path.read_text(encoding="utf-8")
matches = re.findall(r'\[\s*([\d\.]+.*?)\]\((.*?)\)', index_text)
posts = [(title.strip(), (index_path.parent / rel_path).resolve()) for title, rel_path in matches]

# Loop through all matched post files
for i, (title, post_path) in enumerate(posts):
	if not post_path.exists():
		print(f"⚠️ Skipping missing file: {post_path}")
		continue

	# Generate prev/next links
	prev = ""
	next = ""

	if i > 0:
		prev_title, prev_path = posts[i - 1]
		prev_rel = prev_path.with_suffix(".html").relative_to(post_path.parent)
		prev = f"[Previous: {prev_title}]({prev_rel})"

	if i < len(posts) - 1:
		next_title, next_path = posts[i + 1]
		next_rel = next_path.with_suffix(".html").relative_to(post_path.parent)
		next = f"[Next: {next_title}]({next_rel})"

	# Build nav block
	block = "::: {.post-nav}\n"
	if prev:
		block += f"← {prev}"
	if prev and next:
		block += " | "
	if next:
		block += next
	block += "\n:::\n"

	# Print preview for debugging
	print(f"\n🧪 Writing to: {post_path}")
	print("🧱 Block preview:")
	print(block)
	print("🧱 Repeating again:")
	print(block)

	# Append block twice to the file
	content = post_path.read_text(encoding="utf-8").rstrip()
	new_content = content + "\n\n" + block + "\n" + block

	post_path.write_text(new_content, encoding="utf-8")
	print(f"✅ Appended nav blocks: {post_path.name}")