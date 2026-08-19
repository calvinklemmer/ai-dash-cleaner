# ai-dash-cleaner

Kleine Bash-tool die "AI-streepjes" — de en dash (`–`, U+2013) en em dash (`—`, U+2014) — opspoort en vervangt door een gewone hyphen (`-`) in tekst- en documentbestanden. Handig om dit veelvoorkomende AI-tekstkenmerk uit je eigen projectbestanden te halen.

## Wat het doet

- Scant recursief een opgegeven map (of de huidige map als je niks meegeeft) op bestanden met de extensies: `.docx`, `.md`, `.txt`, `.sh`, `.py`
- Zoekt naar en dash (`–`) en em dash (`—`)
- Vervangt beide door een gewone hyphen (`-`)
- Voor `.docx`-bestanden: opent het bestand als zip-archief en herschrijft alleen de tekstlagen (`document.xml`, headers, footers, footnotes, endnotes) — opmaak en overige structuur blijven intact
- Slaat build-artefacten en ruismappen automatisch over: `.git`, `node_modules`, `venv`, `.venv`, `__pycache__`, `dist`, `build`, `.idea`, `.vscode`
- Slaat Word-vergrendelingsbestanden (`~$...`) over
- Toont, als de doelmap een git-repository is, een `git diff --check` en per-bestand diff van alle wijzigingen

## Gebruik

```bash
./remove-ai-dashes.sh [map]
```

Zonder argument wordt de huidige map gescand.

Voorbeeld:

```bash
./remove-ai-dashes.sh ~/Projects/mijn-repo
```

## Vereisten

- bash
- GNU `grep`/`sed` (met `-P`-ondersteuning voor PCRE)
- `python3` (voor de `.docx`-verwerking; standaard aanwezig bij elke Python-installatie, geen extra dependencies)

## Waarom

En dash en em dash komen relatief vaak voor in AI-gegenereerde tekst, terwijl mensen doorgaans de gewone hyphen gebruiken. Dit script normaliseert dat automatisch terug, over meerdere bestandstypen heen — inclusief Word-documenten, waar een simpele `sed`-vervanging het bestand zou corrumperen omdat `.docx` een zip-archief met XML is, geen platte tekst.

## Let op

- `.docx`-bestanden die open staan in Word kunnen niet worden bijgewerkt (bestandslock) — sluit ze eerst.
- Het script wijzigt bestanden **in-place**. Werk bij voorkeur in een git-repository zodat je de wijzigingen kunt reviewen (`git diff --check` gebeurt automatisch) en zo nodig kunt terugdraaien.

## Licentie

MIT — zie [LICENSE](LICENSE).
