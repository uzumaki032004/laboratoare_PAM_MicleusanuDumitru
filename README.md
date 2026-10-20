# Laboratoare PAM — Micleușanu Dumitru

Repository pentru disciplina Programarea Aplicațiilor Mobile.
Toate laboratoarele se păstrează pe un singur branch: `main`, în foldere separate.

| Laborator | Varianta | Aplicația |
| --- | --- | --- |
| [Laboratorul 1](laborator_1/README.md) | 2 | Calculator IMC |
| [Laboratorul 2](laborator_2/README.md) | Magazin vestimentar | GemStore: catalog, detalii, favorite și coș |

Laboratoarele sunt organizate în foldere separate, pe același branch `main`.

Repository: https://github.com/uzumaki032004/laboratoare_PAM_MicleusanuDumitru

## Verificări automate

În tabul **Actions**, workflow-ul **Verificare laborator 1** rulează analiza statică, testele și construiește aplicația Android și web. APK-ul se descarcă din artifactul `calculator-imc-apk` al ultimei rulări reușite.

Pentru laboratorul 2, workflow-ul **Verificare laborator 2** verifică formatul, analiza și testele, apoi generează artifactele `gemstore-lab2-apk` și `gemstore-lab2-web`. Pașii de rulare și prezentare sunt în [README-ul laboratorului 2](laborator_2/README.md).
