# ai-dash-cleaner

Kleine Bash-tool die "AI-streepjes": de 'en dash' ( – , U+2013) en 'em dash' ( — , U+2014): opspoort en vervangt door een gewone hyphen ( - ) in tekst- en documentbestanden. Handig om dit veelvoorkomende AI-tekstkenmerk uit je eigen projectbestanden te halen voordat je deze overhandigt of laat reviewen. 

## Wat het doet

- Scant recursief een opgegeven map (of de huidige map als je niks meegeeft) op bestanden met de extensies: `.docx`, `.md`, `.txt`, `.sh`, `.py`. Meer bestanden nodig? Open de source code en breid de lijst met extensies eenvoudig uit.
- Zoekt naar 'en dash' ( – ) en 'em dash' ( — )
- Vervangt beide door een gewone hyphen (`-`)
- Voor `.docx`-bestanden: opent het bestand als zip-archief en herschrijft alleen de tekstlagen (`document.xml`, headers, footers, footnotes, endnotes): opmaak en overige structuur blijven intact. Dit is uitvoerig getest. 
- Slaat build-artefacten en ruismappen automatisch over: `.git`, `node_modules`, `venv`, `.venv`, `__pycache__`, `dist`, `build`, `.idea`, `.vscode`
- Slaat Word-vergrendelingsbestanden (`~$...`) over
- Toont, als de doelmap een git-repository is, een `git diff --check` en per-bestand diff van alle wijzigingen

## Gebruik

> Status: work in progress. Het menu-skelet hieronder staat; de Scan-optie
> is nog niet gekoppeld aan de daadwerkelijke scanlogica (zie Roadmap).

### Via het menu
```bash
cd ai-dash-cleaner
bash menu.sh
```
```
┌─────────────────────────────┐
│       AI DASH CLEANER       │
│                  v0.1.0-dev │
└─────────────────────────────┘

Menu:
1) Scan
2) Help
3) About

x) Exit
```

### Rechtstreeks (huidige werkende manier)
```bash
./remove-ai-dashes.sh [map/]
```

Voorbeeld:
```bash
./remove-ai-dashes.sh ~/Projects/mijn-repo/
```

Zonder argument wordt de huidige map (en alles eronder) gescand.

## Projectstructuur

```
ai-dash-cleaner/
├── menu.sh                  # entry point
├── lib/
│   ├── colors.sh             # kleurdefinities
│   ├── common.sh             # log_info / log_success / log_warning / log_error
│   ├── globals.sh            # banner (incl. versie) + placeholder-scherm
│   ├── about.sh               # About-scherm
│   ├── help.sh                # Help-scherm
│   └── program-exit.sh       # graceful_exit
├── remove-ai-dashes.sh       # bestaande, werkende scanlogica (nog los van het menu)
├── README.md
└── LICENSE
```

## Vereisten

- Git Bash (bash)
- GNU `grep`/`sed` (met `-P`-ondersteuning voor PCRE)
- `python3` (voor de `.docx`-verwerking; standaard aanwezig bij elke Python-installatie, geen extra dependencies)

## Waarom

'En dash' ( – ) en 'em dash' ( — ) komen relatief vaak voor in AI-gegenereerde tekst, terwijl mensen doorgaans de gewone hyphen '-' gebruiken. Dit script normaliseert dat automatisch terug, over meerdere bestandstypen heen inclusief Word-documenten, waar een simpele `sed`-vervanging het bestand zou corrumperen omdat `.docx` een zip-archief met XML is, geen platte tekst.

## Let op

- `.docx`-bestanden die open staan in Word kunnen niet worden bijgewerkt (bestandslock): sluit ze eerst.
- Het script wijzigt bestanden **in-place**. Werk bij voorkeur in een git-repository zodat je de wijzigingen kunt reviewen (`git diff --check` gebeurt automatisch) en zo nodig kunt terugdraaien.

## Roadmap

- [x] Menu-skelet met Scan / Help / About / Exit
- [x] Echte inhoud voor Help / About
- [ ] ShellCheck + basistests (Bats), lokaal en via CI
- [ ] Scan-optie koppelen aan de bestaande scanlogica (`remove-ai-dashes.sh`)
- [ ] `--dry-run`/`--check`-modus

## Licentie

MIT: zie [LICENSE](LICENSE).
