import os
import re
from pathlib import Path

def parse_index_qmd(index_path):
	content = index_path.read_text(encoding='utf-8')
	post_lines = re.findall(r'\[\s*([^\]]+?)\]\((.*?)\)', content)
	post_info = []
	for title, rel_path in post_lines:
		full_path = (index_path.parent / rel_path).resolve()
		post_info.append((title.strip(), full_path))
	return post_info

def update_prev_next_links_by_index(category_dir):
	print(f"\n🔁 Updating using index.qmd in: {category_dir}")
	category_path = Path(category_dir).resolve()
	index_path = category_path / "index.qmd"
	if not index_path.exists():
		print("❌ index.qmd not found.")
		return

	post_info = parse_index_qmd(index_path)

	for i, (title, post_path) in enumerate(post_info):
		if not post_path.exists():
			print(f"⚠️ Skipping missing file: {post_path}")
			continue

		prev_link = ""
		next_link = ""

		if i > 0:
			prev_title, prev_path = post_info[i - 1]
			prev_rel = os.path.relpath(prev_path.with_suffix('.html'), post_path.parent)
			prev_link = f"[Previous: {prev_title}]({prev_rel})"

		if i < len(post_info) - 1:
			next_title, next_path = post_info[i + 1]
			next_rel = os.path.relpath(next_path.with_suffix('.html'), post_path.parent)
			next_link = f"[Next: {next_title}]({next_rel})"

		footer = "::: {.post-nav}\n"
		if prev_link:
			footer += f"← {prev_link}"
		if prev_link and next_link:
			footer += " | "
		if next_link:
			footer += f"{next_link}"
		footer += "\n:::"

		content = post_path.read_text(encoding='utf-8')
		content = re.sub(r"::: \{\.post-nav\}.*?:::", "", content, flags=re.DOTALL)

		if "---" in content:
			parts = content.rsplit('---', maxsplit=1)
			new_content = parts[0] + '---\n' + footer
		else:
			new_content = content + "\n\n" + footer

		post_path.write_text(new_content.strip() + "\n", encoding='utf-8')
		print(f"✅ Updated: {post_path.name}")

if __name__ == "__main__":
	import sys
	if len(sys.argv) != 2:
		print("Usage: python update_prev_next_indexdriven.py <category-directory>")
	else:
		update_prev_next_links_by_index(sys.argv[1])