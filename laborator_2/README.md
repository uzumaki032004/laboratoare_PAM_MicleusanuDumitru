# Laboratorul 2 PAM — GemStore

**Student:** Micleusanu Dumitru

Aplicație Flutter care reproduce cele două ecrane din captura Figma furnizată: **homepage full** și **product full**. Interfața este implementată separat, cu componente reutilizabile, derulare și navigare între catalog, detalii și coș.

Design: [Laboratoare 2026 — node 2:426](https://www.figma.com/design/3HeBH74VC2MHhKwXGnqI2e/Laboratoare-2026?node-id=2-426). Implementarea vizuală se bazează pe captura trimisă în conversație; nu este un export automat din Figma.

## Ce funcționează

- Homepage cu **Women / Men / Accessories / Beauty**, banner **Autumn Collection 2021**, **Feature Products**, **NEW COLLECTION / HANG OUT & PARTY**, **Recommended** și **Top Collection**.
- Bannerele **FOR SLIM & BEAUTY**, **Most sexy & fabulous design**, **The Office Life** și **Elegant Design**, conform capturii.
- **Show all** deschide listele de produse. Căutarea și favoritele sunt în meniul lateral, pentru a păstra homepage-ul din design.
- Catalog cu 13 produse, fotografii locale și prețuri. Colecția Women conține produsele demonstrative; celelalte trei categorii afișează starea fără produse.
- Filtrare pe categorii: pulovere, rochii, seturi și tricouri.
- Căutare după numele produsului și afișarea unei stări fără rezultate.
- Adăugare/eliminare favorite și vizualizarea produselor favorite.
- Deschiderea detaliilor pentru fiecare produs.
- Pagina **Sportwear Set — $80.00**, fotografia mare, galerie derulabilă, culori și mărimi circulare, **Description / Read more**, **Reviews**, barele de evaluare, două recenzii demonstrative, sortare și **Similar Product**.
- **Write a review** permite adăugarea unui comentariu local în ecranul produsului; comentariul nu este trimis la un server și se resetează când închizi ecranul.
- Selectarea mărimii și culorii și adăugarea prin **Add To Cart**. Pentru Sportwear Set sunt selectate inițial mărimea L și culoarea Bej, ca în captură.
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

1. Arată homepage-ul, derulează până la Recommended și Top Collection și explică asemănarea cu Figma.
2. În Feature Products, derulează lista orizontală până la **Sportwear Set** și apasă produsul.
3. Arată fotografia, prețul **$80.00**, culorile și mărimile; apoi Description, Reviews și Similar Product.
4. Selectează `L` și `Bej` și apasă **Add To Cart**, apoi **View bag** sau pictograma coșului care apare sus.
5. Arată varianta `L · Bej`, mărește cantitatea la 2: totalul devine **$160.00**.
6. Apasă „Finalizează comanda demo”, confirmă și arată coșul gol.
7. Pentru căutare: meniul lateral → Search / All products → `Sweater`. Pentru favorite: apasă inima în detalii sau în lista completă, apoi meniul lateral → Favorites.

## Structură și explicație pentru profesoară

- `main.dart`: `MaterialApp` și tema aplicației.
- `store.dart`: modelele produselor, coșul și favoritele; `ChangeNotifier` anunță actualizările.
- `catalog_page.dart`: homepage din Figma, bannere și liste orizontale; `ProductListingPage` este `StatefulWidget` pentru căutare și filtrare.
- `details_page.dart`: `StatefulWidget` pentru mărimea și culoarea selectate.
- `cart_page.dart`: `StatelessWidget`; datele se actualizează prin `ListenableBuilder`, care ascultă starea comună `Store`.
- `widgets.dart`: cardul produsului, imaginea și butonul coșului, reutilizate între ecrane.
- `test/`: teste unitare și de interfață.

Navigarea folosește `Navigator.push` și `Navigator.pop`. Homepage-ul folosește `SingleChildScrollView`, `Column`, `Stack` și liste orizontale; catalogul complet folosește `CustomScrollView` și `SliverGrid`. Detaliile folosesc `PageView`, `InkWell`, `Semantics`, `Wrap`, `ExpansionTile` și `LinearProgressIndicator`. Pictogramele originale sunt afișate cu `flutter_svg`.

## Referință vizuală

Tema și imaginile pentru exercițiu provin din [laboratorul 2 furnizat ca exemplu](https://github.com/ag234ag/laboratoare_PAM_GorunAndreea/tree/main/laborator_2/fashion_store). Fotografiile sunt păstrate local pentru prezentarea academică; nu sunt imagini create de autorul acestui laborator. Codul interfeței și logica acestei aplicații sunt implementate în fișierele de mai sus. Acesta este doar laboratorul 2; nu introduce implementarea laboratorului 3.
