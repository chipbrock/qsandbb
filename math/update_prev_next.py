import os
from pathlib import Path
import re

def extract_title(path):
    text = path.read_text(encoding='utf-8')
    match = re.search(r'^#\s*(.+)', text, re.MULTILINE)
    return match.group(1).strip() if match else path.stem

def update_prev_next_links(category_dir):
    print(f"\n🔁 Updating: {category_dir}")
    category_path = Path(category_dir)
    post_paths = sorted(category_path.glob("202*/[0-9]*.qmd"))

    for i, post_path in enumerate(post_paths):
        current_title = extract_title(post_path)

        prev_link = ""
        next_link = ""

        if i > 0:
            prev_title = extract_title(post_paths[i - 1])
            prev_rel = f"../{post_paths[i - 1].parent.name}/{post_paths[i - 1].name.replace('.qmd', '.html')}"
            prev_link = f"[Previous: {prev_title}]({prev_rel})"

        if i < len(post_paths) - 1:
            next_title = extract_title(post_paths[i + 1])
            next_rel = f"../{post_paths[i + 1].parent.name}/{post_paths[i + 1].name.replace('.qmd', '.html')}"
            next_link = f"[Next: {next_title}]({next_rel})"

        # Build post-nav block
        footer = "::: {.post-nav}\n"
        if prev_link:
            footer += f"← {prev_link}"
        if prev_link and next_link:
            footer += " | "
        if next_link:
            footer += f"{next_link}"
        footer += "\n:::"

        # Read and clean content
        content = post_path.read_text(encoding='utf-8')
        content = re.sub(r"::: \{\.post-nav\}.*?:::", "", content, flags=re.DOTALL)

        # Inject new nav block
        if "---" in content:
            parts = content.rsplit('---', maxsplit=1)
            new_content = parts[0] + '---\n' + footer
        else:
            new_content = content + "\n\n" + footer

        # Force write and flush to disk
        with open(post_path, "w", encoding="utf-8") as f:
            f.write(new_content.strip() + "\n")
            f.flush()

        print(f"✅ Updated: {post_path.name}")

if __name__ == "__main__":
    update_prev_next_links(".")
    update_prev_next_links(".")