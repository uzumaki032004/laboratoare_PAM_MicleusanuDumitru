# Laboratorul 2 PAM — GemStore

**Student:** Micleusanu Dumitru

Aplicație Flutter de magazin vestimentar, realizată pe baza temei vizuale din exemplul de laborator 2 al colegei. Interfața este implementată separat, cu layout adaptabil, componente reutilizabile și navigare între catalog, detalii și coș.

## Ce funcționează

- Catalog cu opt produse, fotografii locale și prețuri.
- Filtrare pe categorii: pulovere, rochii, seturi și tricouri.
- Căutare după numele produsului și afișarea unei stări fără rezultate.
- Adăugare/eliminare favorite și vizualizarea produselor favorite.
- Deschiderea detaliilor pentru fiecare produs.
- Selectarea mărimii și culorii, descriere, livrare și recenzie demonstrativă.
- Coș comun tuturor ecranelor, cu variante separate și reunirea produselor identice.
- Schimbarea cantității, eliminarea produselor și calcularea exactă a totalului în cenți.
- Confirmarea unei comenzi demonstrative și golirea coșului.
- Navigare înapoi, meniu lateral și ecran de informații despre aplicație.

Datele sunt locale. Aplicația funcționează fără internet după instalare. Coșul și favoritele se păstrează în memorie în timpul sesiunii și se resetează la repornire. Selectarea culorii schimbă varianta din coș; fotografia este una de prezentare. Nu există conturi, server, plăți sau comenzi reale.

## Rulare în VS Code

Deschide folderul `laborator_2`, instalează extensia **Flutter** (include Dart), apoi rulează:

```sh
flutter pub get
flutter devices
flutter run -d ID_DISPOZITIV
```

Pentru emulator: pornește un dispozitiv din Android Studio → Device Manager, selectează-l în bara de jos a VS Code și apasă **F5**. În timpul depanării, **Hot Reload** actualizează interfața.

Pentru browser:

```sh
flutter run -d chrome
```

Necesită Flutter stable cu Dart compatibil cu `pubspec.lock`, Android SDK și Java 17 pentru Android. Dacă Windows blochează Dart prin Application Control, rularea Flutter necesită rezolvarea acelei restricții de către administrator; APK-ul construit în GitHub Actions se poate instala separat.

## APK pentru telefon

Deschide tabul **Actions** din repository, alege ultima rulare reușită **Verificare laborator 2**, apoi descarcă artifactul **gemstore-lab2-apk**.

- `app-arm64-v8a-debug.apk`: pentru majoritatea telefoanelor Android actuale.
- `app-x86_64-debug.apk`: pentru emulatorul Android x86_64 de pe calculator.
- `app-armeabi-v7a-debug.apk`: pentru dispozitive Android ARM de 32 de biți.

Pentru a genera APK-urile local:

```sh
flutter build apk --debug --split-per-abi
```

## Verificare

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
```

Workflow-ul verifică formatul, analiza, testele și construiește versiunile web și Android. Testele acoperă variantele și cantitățile din coș, totalurile, favoritele, căutarea, traseul complet de cumpărare demonstrativă și ecranele de 320 px.

## Scenariu scurt de prezentare

1. Arată catalogul și filtrează categoria „Rochii”. Revino la „Toate”.
2. Caută `Sweater`, apoi șterge căutarea.
3. Apasă inima unui produs, deschide lista de favorite și revino în catalog.
4. Deschide `Turtleneck Sweater`, selectează mărimea `L` și culoarea `Bej`.
5. Apasă „Adaugă în coș”, apoi pictograma coșului din dreapta sus.
6. Arată varianta `L · Bej`, mărește cantitatea la 2: totalul devine **$79.98**.
7. Apasă „Finalizează comanda demo”, confirmă și arată coșul gol.

## Structură și explicație pentru profesoară

- `main.dart`: `MaterialApp` și tema aplicației.
- `store.dart`: modelele produselor, coșul și favoritele; `ChangeNotifier` anunță actualizările.
- `catalog_page.dart`: `StatefulWidget` pentru categoria, căutarea și filtrul de favorite selectate.
- `details_page.dart`: `StatefulWidget` pentru mărimea și culoarea selectate.
- `cart_page.dart`: `StatelessWidget`; datele se actualizează prin `ListenableBuilder`, care ascultă starea comună `Store`.
- `widgets.dart`: cardul produsului, imaginea și butonul coșului, reutilizate între ecrane.
- `test/`: teste unitare și de interfață.

Navigarea folosește `Navigator.push` și `Navigator.pop`. Catalogul folosește `CustomScrollView`, `SliverGrid` și `SliverLayoutBuilder`; detaliile folosesc `SingleChildScrollView`, `ChoiceChip` și `ExpansionTile`.

## Referință vizuală

Tema și imaginile pentru exercițiu provin din [laboratorul 2 furnizat ca exemplu](https://github.com/ag234ag/laboratoare_PAM_GorunAndreea/tree/main/laborator_2/fashion_store). Fotografiile sunt păstrate local pentru prezentarea academică; nu sunt imagini create de autorul acestui laborator. Codul interfeței și logica acestei aplicații sunt implementate în fișierele de mai sus. Acesta este doar laboratorul 2; nu introduce implementarea laboratorului 3.
