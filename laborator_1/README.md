# Laboratorul 1 — Varianta 2: Calculator IMC

**Student:** Micleușanu Dumitru  
**Disciplina:** Programarea Aplicațiilor Mobile

## Cerință

Aplicație mobilă Flutter care calculează indicele de masă corporală pe baza greutății (kg) și înălțimii (cm). Folosește două `TextField`, un `ElevatedButton` și afișează valoarea IMC și categoria în widgeturi `Text`.

## Funcționare

Formula: `IMC = greutateKg / (înălțimeCm / 100)²`.

Acceptă punct sau virgulă zecimală. Câmpurile goale, textul, zero și valorile negative produc mesaje de eroare. Editarea datelor elimină rezultatul anterior. Interfața în română se poate derula pe ecrane mici și când tastatura este deschisă. Calculul funcționează fără internet.

| IMC | Categoria |
| --- | --- |
| < 18,5 | Subponderal |
| 18,5 – < 25 | Normal |
| 25 – < 30 | Supraponderal |
| 30 – < 35 | Obezitate grad I |
| 35 – < 40 | Obezitate grad II |
| ≥ 40 | Obezitate grad III |

Clasificarea se face înainte de rotunjire; valoarea afișată are două zecimale.
Pragurile sunt pentru adulți, conform [clasificării OMS](https://applications.emro.who.int/dsaf/EMROPUB_2014_EN_1822.pdf?ua=1).

## Rulare

Instalează [Flutter](https://docs.flutter.dev/install) și Android Studio cu Android SDK. Pornește un emulator sau conectează un telefon Android cu USB debugging activat.

Din folderul `laborator_1`:

```sh
flutter pub get
flutter devices
flutter run -d ID_DISPOZITIV
```

Pentru prezentare în browser:

```sh
flutter run -d chrome
```

Pentru APK instalabil pe Android:

```sh
flutter build apk --release
```

APK-ul este generat în `build/app/outputs/flutter-apk/app-release.apk`.

După publicarea pe GitHub, workflow-ul din tabul **Actions** verifică laboratorul și construiește un APK de test. Deschide ultima rulare reușită **Verificare laborator 1**, descarcă artifactul **calculator-imc-apk**, dezarhivează și instalează `app-debug.apk` pe telefon. Android poate cere permisiunea de instalare din sursa respectivă.

## Verificare

```sh
flutter analyze
flutter test
```

Testele verifică formula, pragurile, validarea și utilizarea interfeței pe ecran mic.

## Scenariu de prezentare

1. Explică cele două câmpuri și butonul `Calculează IMC`.
2. Introdu `70` kg și `175` cm: rezultatul este **22.86 — Normal**.
3. Introdu `95` kg și `175` cm: rezultatul este **31.02 — Obezitate grad I**.
4. Introdu `50` kg și `175` cm: rezultatul este **16.33 — Subponderal**.
5. Arată că `70,5` este acceptat și că înălțimea `0` produce eroare.
6. Explică transformarea cm în m și formula din `lib/imc.dart`.

## Structură

- `lib/main.dart`: interfață, controllere, stare și mesaje de validare.
- `lib/imc.dart`: conversia datelor, formula și clasificarea.
- `test/`: teste de logică și interfață.
- `android/`: proiectul mobil Android.
- `web/`: suport pentru rularea în browser.
