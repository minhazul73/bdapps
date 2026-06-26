# Student Grade Tracker App

A premium, modern Flutter application built to track student course grades, calculate overall performance metrics, and toggle dynamically between custom Light and Dark themes.

## 🚀 Key Features
*   **MVC Architecture**: Clean separation of concerns with Models, Views, and Controllers (Provider).
*   **Add Subject Form**: A fully validated input form for recording subject names and marks (0-100).
*   **Live Subject List**: A listing of all recorded subjects with color-coded grade badges and "swipe-to-delete" using `Dismissible` (complete with an Undo action!).
*   **Performance Dashboard (Summary)**: Shows real-time statistics including total subjects, average mark, passing rate, and overall letter grade.
*   **Dynamic Theme Toggle**: Instantly switch between custom dark and light themes. No default themes are used; all colors are resolved dynamically from `Theme.of(context)`.
*   **Reactive State Management**: Uses the `provider` package to manage the entire application state with **zero `setState` calls** across the codebase.
*   **Persistent Local Storage**: Uses `shared_preferences` to automatically save and restore all subject data and the selected theme across app restarts.

---

## 🏗️ Architecture (MVC Pattern)
The application adheres strictly to the Model-View-Controller pattern, leveraging `provider` to bridge data and user interface components:

1.  **Model (`lib/models/subject.dart`)**
    *   Defines the `Subject` class containing `name` and a private `_mark` field.
    *   Exposes a public getter `double get mark => _mark`.
    *   Implements a public getter `String get grade` returning:
        *   `A` (≥ 80)
        *   `B` (≥ 65)
        *   `C` (≥ 50)
        *   `F` (under 50)
2.  **Controller (`lib/controllers/grade_tracker_provider.dart`)**
    *   Exposes properties for `subjects`, `currentIndex` (for navigation), and `themeMode`.
    *   Uses `.where()` to filter passing and failing subjects.
    *   Uses `.map()` to extract scores and compute the average mark dynamically.
    *   Manages operations like `addSubject`, `deleteSubject`, `insertSubject` (Undo), `setCurrentIndex`, and `toggleTheme`.
    *   **SharedPreferences Integration**:
        *   `_loadData()` — called in the constructor; reads persisted data on every app launch.
        *   `_saveSubjects()` — serialises the `_subjects` list to a JSON string and writes it under the key `'subjects'`.
        *   `_saveTheme()` — persists the current theme preference as a boolean under the key `'isDarkMode'`.
        *   Every mutating operation (`addSubject`, `deleteSubject`, `insertSubject`, `toggleTheme`) triggers the corresponding save method so the app state is never lost.
3.  **View (`lib/views/`)**
    *   `themes/app_themes.dart`: Configures premium slate/teal/violet custom themes (Light and Dark) with high-contrast text, custom text field borders, and cards.
    *   `screens/main_navigation_screen.dart`: The frame containing the App Bar, Bottom Navigation Bar, and Theme toggle.
    *   `screens/add_subject_screen.dart`: The input form screen.
    *   `screens/subject_list_screen.dart`: The swipe-to-delete list.
    *   `screens/summary_screen.dart`: The analytics dashboard.

---

## 🛠️ How to Run the App

### Prerequisites
Make sure you have Flutter installed and configured on your system. You can verify your environment by running:
```bash
flutter doctor
```

### Setup and Running Instructions

1.  **Clone the repository**:
    ```bash
    git clone <repository_url>
    cd assignment02-student_grade_tracker
    ```

2.  **Get packages**:
    Fetch all dependencies, including `provider` and `shared_preferences`:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    Run the app on a connected device (simulator, emulator, or physical device):
    ```bash
    flutter run
    ```
