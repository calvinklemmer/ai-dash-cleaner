#!/usr/bin/env bash
set -u

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SELF="$(basename "$0")"
ROOT="${1:-.}"

# Alleen deze extensies scannen — bestanden waar je zelf tekst/code in schrijft
EXTENSIONS=(docx md txt sh py)

# Ruis-mappen altijd overslaan
EXCLUDE_DIRS=(.git node_modules venv .venv __pycache__ dist build .idea .vscode)

echo "Scannen op verdachte AI-streepjes in: $ROOT (extensies: ${EXTENSIONS[*]})"
echo

PRUNE_EXPR=()
for d in "${EXCLUDE_DIRS[@]}"; do
    PRUNE_EXPR+=(-path "*/$d" -prune -o)
done

NAME_EXPR=()
for i in "${!EXTENSIONS[@]}"; do
    ((i > 0)) && NAME_EXPR+=(-o)
    NAME_EXPR+=(-iname "*.${EXTENSIONS[$i]}")
done

mapfile -t FILES < <(find "$ROOT" "${PRUNE_EXPR[@]}" -type f \( "${NAME_EXPR[@]}" \) -print \
    | grep -v '/~\$' \
    | sort -u)

FOUND=()
CLEANED=()

replace_in_text_file() {
    local file="$1"
    if grep -Iq . "$file" 2>/dev/null && grep -qP '[–—]' "$file" 2>/dev/null; then
        FOUND+=("$file")
        echo -e "${YELLOW}WARNING${NC}: verdachte AI-streepjes gevonden in: $file"
        grep -nP '[–—]' "$file"
        sed -i 's/–/-/g; s/—/-/g' "$file"
        CLEANED+=("$file")
        echo
        echo -e "${GREEN}OK${NC}: opgeschoond: $file"
        echo
    fi
}

replace_in_docx_file() {
    local file="$1"
    local result
    result=$(python3 - "$file" <<'PYEOF'
import sys, zipfile, shutil, tempfile, os

path = sys.argv[1]
targets = {"word/document.xml", "word/footnotes.xml", "word/endnotes.xml",
           "word/header1.xml", "word/header2.xml", "word/header3.xml",
           "word/footer1.xml", "word/footer2.xml", "word/footer3.xml"}

try:
    changed = False
    tmp_fd, tmp_path = tempfile.mkstemp(suffix=".docx")
    os.close(tmp_fd)

    with zipfile.ZipFile(path, "r") as zin, zipfile.ZipFile(tmp_path, "w", zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            if item.filename in targets:
                text = data.decode("utf-8")
                new_text = text.replace("–", "-").replace("—", "-")
                if new_text != text:
                    changed = True
                    data = new_text.encode("utf-8")
            zout.writestr(item, data)

    if changed:
        shutil.move(tmp_path, path)
        print("CHANGED")
    else:
        os.remove(tmp_path)
        print("UNCHANGED")
except (FileNotFoundError, zipfile.BadZipFile, PermissionError) as e:
    print(f"SKIP: {e}", file=sys.stderr)
    print("UNCHANGED")
PYEOF
)
    if [[ "$result" == "CHANGED" ]]; then
        FOUND+=("$file")
        CLEANED+=("$file")
        echo -e "${YELLOW}WARNING${NC}: verdachte AI-streepjes gevonden en opgeschoond in: $file"
    fi
}

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "$SELF" ]] && continue

    case "$file" in
        *.docx|*.DOCX) replace_in_docx_file "$file" ;;
        *)              replace_in_text_file "$file" ;;
    esac
done

if ((${#FOUND[@]} == 0)); then
    echo -e "${GREEN}OK${NC}: geen verdachte AI-streepjes gevonden."
    exit 0
fi

echo "----------------------------------------"
echo "Opgeschoonde bestanden:"
printf ' - %s\n' "${CLEANED[@]}"

if git -C "$ROOT" rev-parse --is-inside-work-tree &>/dev/null; then
    echo
    echo "Git diff --check:"
    if git -C "$ROOT" diff --check; then
        echo -e "${GREEN}OK${NC}: git diff --check geeft geen problemen."
    else
        echo -e "${RED}LET OP${NC}: git diff --check rapporteert problemen."
    fi

    echo
    echo "Wijzigingen per opgeschoond tekstbestand (git-tracked; .docx overgeslagen):"
    for file in "${CLEANED[@]}"; do
        [[ "$file" == *.docx ]] && continue
        echo
        echo "===== $file ====="
        git -C "$ROOT" diff -- "$file"
    done
else
    echo
    echo "Geen git-repository gedetecteerd in $ROOT — diff-overzicht overgeslagen."
fi
