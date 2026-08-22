# 💰 Mini Expense Tracker

A modern, clean, and feature-packed Flutter application to manage daily personal expenses, track monthly budgets, and analyze spending breakdowns with interactive charts.

---

## ✨ Features

- 🔐 **User Authentication**: Secure Login & Registration using Firebase Auth with session persistence via `SharedPreferences`.
- 📊 **Real-time Synchronization**: Instant data sync across devices with Cloud Firestore.
- 📈 **Category Breakdown & Charts**: Interactive spending visualizations built using `fl_chart`.
- 🎨 **Modern Design & Dark Mode**: Responsive UI using `flutter_screenutil`, Custom Theme Controller, and Google Fonts.
- 📱 **Filter & Search**: Easily filter expenses by category or search notes and amounts.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Backend & Database**: Firebase Auth & Cloud Firestore
- **Local Persistence**: `SharedPreferences` & `flutter_dotenv`
- **Charts**: `fl_chart`
- **Responsive Layout**: `flutter_screenutil`

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.24.0 or above)
- Android Studio / VS Code with Flutter extension
- Firebase project setup

### 1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/mini_expense_tracker.git
cd mini_expense_tracker
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Environment Setup (.env)
Copy `.env.example` to `.env` and fill in your Firebase API credentials:
```bash
cp .env.example .env
```

Fill in your environment keys inside `.env`:
```env
FIREBASE_WEB_API_KEY=your_web_api_key
FIREBASE_ANDROID_API_KEY=your_android_api_key
FIREBASE_IOS_API_KEY=your_ios_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_STORAGE_BUCKET=your_storage_bucket
```

### 4. Run the app
```bash
flutter run
```

---

## 🧪 Running Tests & Analysis

To verify code quality and pass static analysis:
```bash
flutter analyze
flutter test
```

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
