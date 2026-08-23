# Mini Expense Tracker

Mini Expense Tracker is a Flutter app built to log daily personal expenses, track monthly budgets, and view category spending charts. It uses GetX for state management, SQLite (`sqflite`) for offline local storage, and Firebase Cloud Firestore for real-time cloud sync.

**Author:** Md. Shohanur rahaman

---

## Key Features

- **Authentication**: Email and password sign-in and registration powered by Firebase Auth with persistent sessions via `SharedPreferences`.
- **Offline-First Storage**: Local database storage using SQLite (`sqflite`). Expenses load instantly without waiting for network requests.
- **Cloud Sync**: Dual storage flow that saves entries locally and syncs with Cloud Firestore when online.
- **Search & Filter**: Real-time search across notes, amounts, and categories with category filter chips.
- **Charts & Breakdown**: Category-wise spending visualization using `fl_chart`.
- **Responsive Layout**: Screen scaling using `flutter_screenutil` and layout constraints for mobile, tablet, and desktop viewports.
- **Dark Mode**: Theme toggling persisted locally via `ThemeController`.
- **Automated CI/CD**: GitHub Actions workflow for linting (`flutter analyze`), unit testing (`flutter test`), and compiling release Android APKs.

---

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management & Routing**: GetX
- **Local Database**: sqflite, path
- **Backend & Auth**: Firebase Auth, Cloud Firestore
- **Local Cache**: SharedPreferences
- **Charts**: fl_chart
- **UI & Scaling**: flutter_screenutil, google_fonts
- **Configuration**: flutter_dotenv

---

## Project Structure

```text
lib/
├── core/
│   ├── binding/          # Global GetX bindings
│   ├── global_widget/    # Shared UI components (inputs, buttons, cards, dialogs)
│   ├── route/           # App routes and navigation pages
│   ├── service/         # Firebase Auth, SQLite DB, and Storage services
│   ├── theme/           # Color palettes, text styles, and theme controller
│   ├── utility/         # Constants and date/currency formatters
│   └── validation/      # Form input validation rules
│
├── feature/
│   ├── auth/            # Login and Register views and controller
│   ├── dashboard/       # Bottom navigation wrapper
│   ├── expense/         # Expense list, chart, add/edit views and controller
│   ├── home/            # Overview dashboard
│   └── profile/         # Profile overview and theme toggle
│
├── app.dart             # Root MaterialApp configuration
├── firebase_options.dart # Dynamic Firebase setup
└── main.dart            # Application entry point
```

---

## Local Database (SQLite)

Local storage is handled by `LocalDatabaseService` using `sqflite`:

- **Database**: `expense_tracker.db`
- **Table**: `expenses`
- **Fields**: `id`, `userId`, `amount`, `category`, `date`, `note`, `createdAt`

### Storage Flow
1. **Reads**: The app reads expenses directly from the local SQLite database first so screens render immediately.
2. **Writes**: Adding, updating, or deleting an expense executes on SQLite first and sends updates to Firestore.
3. **Batch Inserts**: Bulk data fetched from Firestore is written to SQLite in a batch operation.

---

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/flutter_ci.yml`) runs on pushes and pull requests to `main`:

1. **Static Analysis**: Executes `flutter analyze`.
2. **Testing**: Runs the automated test suite with `flutter test`.
3. **Build**: Builds `app-release.apk` for Android using environment variables from GitHub Secrets.
4. **Release**: Automatically drafts a GitHub Release containing the APK.

---

## Testing

The project includes unit tests in `test/widget_test.dart` covering:

- Form validation rules (email, password, amounts)
- `ExpenseModel` JSON and SQLite map serialization
- Category total and monthly spending calculations
- Date and currency formatting
- Category and search query filter logic

To run tests locally:

```bash
flutter test
```

To run static analysis:

```bash
flutter analyze
```

---

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/shohanur55/mini_expense_tracker.git
cd mini_expense_tracker
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Setup environment variables
Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

Add your Firebase configuration keys into `.env`:
```env
FIREBASE_WEB_API_KEY=your_web_api_key
FIREBASE_ANDROID_API_KEY=your_android_api_key
FIREBASE_IOS_API_KEY=your_ios_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_STORAGE_BUCKET=your_storage_bucket
```

### 4. Firebase Setup Using CLI

1. **Install Node.js & npm**:
   Download from [Node.js Official Prebuilt Installer](https://nodejs.org/en/download/prebuilt-installer).

2. **Run CLI setup commands in terminal**:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   flutterfire configure
   ```

3. **Known Issues & Solutions**:
   - **`firebase` is not recognized**: Setup the `firebase` executable path in your system environment variables.
   - **`firebase.ps1` cannot be loaded**: Running scripts is disabled on Windows PowerShell. Solution available on [StackOverflow](https://stackoverflow.com/questions/72111770/firebase-ps1-cannot-be-loaded-because-running-scripts-is-disabled-on-this-system).

4. **Official Documentation**:
   - [Firebase Official Doc for Flutter](https://firebase.flutter.dev/docs/overview)

### 5. Run the app
```bash
flutter run
```

---

## Author & License

- **Author**: Md. Shohanur rahaman

