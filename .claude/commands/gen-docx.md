# Markdown to DOCX Converter

Convert a markdown file into a professionally styled DOCX document suitable for Google Docs or stakeholder sharing.

## Arguments

`$ARGUMENTS` — One of:
- `<input.md>` — convert this markdown file to DOCX (output defaults to same name with .docx extension)
- `<input.md> <output.docx>` — convert with explicit output path

If no arguments are provided, look for a markdown file in the current directory and ask the user which one to convert.

---

## Your Task

Convert the given markdown report into a styled DOCX using the `gen_docx.py` script from the user's dotfiles.

### Step 1 — Validate inputs

- Confirm the input markdown file exists. If `$ARGUMENTS` is empty, list `.md` files in the current directory and ask the user which to convert.
- Determine the output path: if not specified, use `<input_stem>.docx` in the same directory as the input.

### Step 2 — Ensure python-docx is installed

Run:
```bash
python3 -c "import docx" 2>/dev/null || pip install python-docx
```

### Step 3 — Run the converter

The script lives at `~/Documents/dotfiles/scripts/gen_docx.py`. Run it:

```bash
python3 ~/Documents/dotfiles/scripts/gen_docx.py <input.md> <output.docx>
```

### Step 4 — Report the result

Tell the user:
- Where the DOCX was saved
- How many tables, images, and headings were in the source markdown (count them from the file)
- Remind them they can upload the DOCX to Google Drive and open with Google Docs to preserve styling

## Styling Details (for reference)

The script produces a professionally styled document with:
- **Blue header rows** (#2F5496) with white text on all tables
- **Alternating gray rows** (#F2F2F2) for readability
- **Yellow highlight** (#FFF2CC) on rows containing `**bold**` markdown
- **Calibri** body font (10pt), **Consolas** for inline `code` (red)
- Full-width tables with visible borders (#BFBFBF)
- Images left-aligned, resolved relative to the markdown file's directory
- Headings in blue (#2F5496), sized by level (22pt title, 16/13/11pt h1-h3)
- 2.2cm page margins, 1.15 line spacing

## Supported Markdown Elements

- `# Heading` through `#### Heading`
- `| table | rows |` (with `|---|---|` separator)
- `![alt](image/path.png)` — images (relative paths resolved from .md location)
- `- bullet items`
- `**bold**` and `` `code` `` inline formatting
- `---` horizontal rules (skipped in output)
- Regular paragraphs (consecutive non-blank lines merged)
