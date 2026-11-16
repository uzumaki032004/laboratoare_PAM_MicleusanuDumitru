# Laboratorul 3 PAM — Learning App (BLoC/Cubit + JSON asincron)

**Student:** Micleusanu Dumitru

Aplicație Flutter de învățare construită pe datele din `assets/data/lab_v4.json` (ecranul **Home** și ecranul **Course Overview**). Datele sunt încărcate asincron, starea este gestionată cu **Cubit** din pachetul `flutter_bloc`, iar interfața este împărțită în ecrane și componente reutilizabile.

## Cerințe acoperite

| Cerință | Unde se vede în aplicație | Unde este în cod |
| --- | --- | --- |
| State management (BLoC/Cubit) | toate ecranele | `lib/logic/` (`HomeCubit`, `LessonsCubit`, `FavoritesCubit`) |
| Date din JSON, încărcate asincron | la pornire apare Loading, apoi datele | `lib/data/repositories/learning_repository.dart` (`rootBundle.loadString` + `async/await`) |
| Modelarea datelor | — | `lib/data/models/` (`fromJson`, validare cu `FormatException`) |
| Stările Loading / Success / Empty / Error | spinner la pornire; lista; căutare fără rezultate, tab-ul Description, Favorites gol; meniul ⋮ → *Simulate error* | `home_state.dart` (clase `sealed`), `LoadStatus` în `lessons_state.dart`, `state_views.dart` |
| Căutare | câmpul *Search lessons* | `LessonsCubit.search` + `applyLessonQuery` |
| Filtrare | chip-urile All / Available / Locked / Completed | `LessonFilter` |
| Sortare | butonul de sortare de lângă filtre | `LessonSort` |
| Favorite | inima de pe fiecare lecție, pagina Favorites | `FavoritesCubit`, `favorites_screen.dart` |
| Pagina de detalii | apăsare pe o lecție | `lesson_details_screen.dart` |
| Componente reutilizabile | carduri, tile-uri, vederi de stare | `lib/presentation/widgets/` |

Funcții suplimentare: **Enroll Now** deblochează lecția blocată, lecțiile pot fi marcate ca finalizate (progresul se actualizează), butonul *Next* trece la lecția următoare, pull-to-refresh pe ecranul principal.

## Structura proiectului

```
laborator_3/
├── assets/data/lab_v4.json        # datele aplicației
├── lib/
│   ├── main.dart                  # runApp(LearningApp(...))
│   ├── app.dart                   # MaterialApp + MultiBlocProvider
│   ├── core/                      # culori, temă, formatare, JsonIcon
│   ├── data/
│   │   ├── models/                # Lesson, Course, HomePageData, AppData...
│   │   └── repositories/          # LearningRepository (încărcare asincronă)
│   ├── logic/                     # Cubit-uri și stări
│   │   ├── home/                  # HomeCubit + HomeState (sealed)
│   │   ├── lessons/               # LessonsCubit, LessonsState, căutare/filtre/sortare
│   │   └── favorites/             # FavoritesCubit
│   └── presentation/
│       ├── navigation.dart        # navigarea între ecrane
│       ├── screens/               # Home, Course Overview, Lesson Details, Favorites
│       └── widgets/               # common/, home/, course/
└── test/                          # teste pentru modele, logică și interfață
```

Fluxul datelor: **JSON → Repository (async) → Cubit (emit stare) → BlocBuilder → Widget-uri**.

## Cum se pornește

Din rădăcina repository-ului:

```sh
cd laborator_3
flutter pub get
flutter run -d chrome        # în browser
# sau
flutter devices
flutter run -d ID_DISPOZITIV # emulator / telefon Android
```

În VS Code: **File → Open Folder → `laborator_3`**, apoi alege dispozitivul în bara de jos și apasă **F5**.

Imaginile și avatarul vin de pe internet (URL-urile din JSON). Fără internet, aplicația funcționează, iar în locul imaginilor apare o pictogramă de rezervă. Pictogramele Iconify din JSON sunt desenate local cu pictogramele Material echivalente, păstrând culoarea din URL.

## Verificare

```sh
flutter analyze
flutter test
```

Workflow-ul **Verificare laborator 3** din tabul *Actions* rulează analiza și testele și generează artifactele `learning-lab3-web` și `learning-lab3-apk`.

## Scenariu de prezentare

1. Pornește aplicația: apare **Loading** (~1 secundă), apoi ecranul **Hi, Kristin** (*Success*).
2. Arată cardurile *Learned today* (46min / 60min), *Learning Plan* și *Meetup* — toate textele și valorile vin din JSON.
3. Meniul **⋮** din antet → **Simulate error**: apare starea **Error**; apasă **Retry** pentru a reveni. **Reload data** arată din nou Loading.
4. Apasă **Get Started** (sau *My courses*) → pagina **Course Overview**.
5. Scrie `react` în căutare, apoi `kotlin` → starea **Empty** cu butonul *Reset filters*.
6. Alege filtrul **Locked**, apoi sortarea **Longest first**.
7. Apasă inima la o lecție, apoi pictograma inimă din bara de sus → pagina **Favorites**.
8. Apasă o lecție → **pagina de detalii** → *Mark as completed*; înapoi în listă apare *Done* și „1 of 4 lessons completed”.
9. Deschide lecția **Build React** (blocată) → **Enroll Now** o deblochează.
10. Tab-ul **Description** → textul din JSON este gol, deci se afișează starea **Empty**.

## Explicație scurtă pentru profesoară

- **Cubit** este varianta simplificată a BLoC: în loc de evenimente, UI-ul apelează metode (`search`, `setFilter`, `toggle`), iar Cubit-ul emite o stare nouă cu `emit`.
- `HomeState` este `sealed`, deci `switch` din `HomeScreen` trebuie să trateze toate stările (Loading, Success, Empty, Error) — compilatorul verifică acest lucru.
- `LessonsState` păstrează pe lângă `status` și căutarea, filtrul, sortarea și tab-ul, ca acestea să nu se piardă la reîncărcare.
- Logica de căutare/filtrare/sortare este funcția pură `applyLessonQuery`, testată separat de interfață.
- Repository-ul este o interfață (`LearningRepository`); în teste se folosește `FakeLearningRepository` și `FailingLearningRepository`.
- Favoritele și progresul se păstrează în memorie pe durata sesiunii.
