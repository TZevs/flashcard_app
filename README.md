# Flashcard Study App
<img width="187" height="402" alt="flashcard_wireframe" src="https://github.com/user-attachments/assets/a9a9e799-e78d-4522-a160-9dceabc72208" />
<br>
Screenshot: Wireframe of the main page of the app

## 🎓 About This Project
> This is my mobile development module **assignment** project for Software Engineering at Sheffield Hallam University (2025). It was developed to meet a marking criteria, so it is **not at a production-level standard**.

🫟 **Problem:** Watching my sister revise for her A-levels using paper flashcards showed me how inconvenient the cards are to create, organise and handle. This app gives students an organised collection of flashcard decks they can access anytime, without worrying about losing any. 

🚪 **Approach:** The app is built with Flutter and Dart, following the **MVVM** (**Model-View-ViewModel**) architecture pattern, keeping the UI separate from the app logic and data access. 
- **Model:** the data classes and functions that translate fetched and to be saved data.
- **View:** the screens and widgets the user sees. They display data and pass user actions to the ViewModel, has not business logic of its own.
- **ViewModel:** hols the state and logic for each screen, talks to the Model layer.

### ✨ Features
- Create, edit, and delete decks of flashcards.
- Add images to cards via an upload point from gallery or directly from the phone's camera.
- Use study cards with swipe gesture navigation and tap-to-flip card interactions. 
- Sign in using email/password or Google account using Firebase Authentication.
- Browse and search public decks created by other users.
- Keep decks private (on-device) or make them public (shared).

🚦 **Status:** Features are implemented, but I could not get the IOS build to run reliably during development. The problems I have encountered since appear to be specific to my machine rather than the code. 

---
### 🛠️ Tech Stack
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
<br>
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
<br>
![Firebase](https://img.shields.io/badge/firebase-%23DD2C00.svg?style=for-the-badge&logo=firebase&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white)

### 🏛️ Project Structure
```
flashcard_app/
├── lib/                # App source code (MVVM)
│   ├── models/         # Data classes (decks & cards)
│   ├── views/          # App screens
│   ├── viewmodels/     # Communication between views and models
│   ├── services/       # DB connections (Firebase & SQLite), notification setup
|   ├── widgets/        # Features on the screens/views
│   └── main.dart       # App entry point
├── test/               # Tests
├── imgs/               
├── pubspec.yaml        # Dependencies and assets
└── android/ ios/ linux/ macos/ web/ windows/   # Flutter platform folders (generated)
```
---
## 📦 Setup
### 🚀 Installation
```bash
git clone https://github.com/TZevs/flashcard_app.git
cd flashcard_app
flutter pub get    # Install Dependencies
```
#### Dependencies
- Flutter SDK [Install Here](https://docs.flutter.dev/install)
- VSC Extension: Flutter
- VSC Extension: Dart (Should auto install via Flutter extension)
- An Emulator or a physical device.
#### Firebase configuration
The app uses Firebase Authentication and a Firebase database, so you need a Firebase project of your own:
1. Create a project in the [Firebase console](https://firebase.google.com) and enable Email/Password and Google sign-in.
2. Add your platform config: `google-services.json` for Android (in `android/app`).

### Usage
```bash
flutter run
```
Or open `lib/main.dart` in your editor and press Run.

---
## 🔍 Known Issues & Improvements to be Made
- **iOS / macOS build:** the app would not build or run on iPhone from my macOS setup. The cause looks specific to my development environment.
- Platforms other than the one I tested on, Windows, have not been verified.

**Lesson learned:** check cross-platform compatibility at the start of a project, not at the end.

---
## 🤝 Credits
This project was created as a module assignment for my degree at Sheffield Hallam University.

## 📄 Licence
This project is licensed under the MIT License.
