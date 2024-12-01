# Task Manager App By Mohammad Al Bali

### Description
The Task Manager App is a robust and feature-rich application built using **Flutter**.
It enables users to manage tasks efficiently with functionalities like authentication, task CRUD operations, pagination, and state management.
The app is designed following Flutter best practices, with a focus on performance, clean code, and intuitive user experience following **Google Material 3 Design Rules**.

---

## Features

1. **User Authentication**
   - Secure login using `https://dummyjson.com/docs/auth`.
   - Validates username and password and fetches user details based on the authentication token.

2. **Task Management**
   - Add, view, edit, and delete tasks.
   - User-specific task management with distinct endpoints for personal and global tasks.

3. **Pagination**
   - Efficient task retrieval using paginated APIs (`https://dummyjson.com/todos?limit=30&skip=30`).
   - Lazy Loading by listening to screen scrolls to effectively fetch more data

4. **State Management**
   - Implemented using **BLoC** for efficient and scalable application state handling.

5. **Local Storage**
   - Tasks are stored persistently using **SQFLite** for local data availability.
   - Settings like themes, language preferences and tokens are managed via **SharedPreferences**.

6. **Localization**
   - Multi-language support for English and Arabic, seamlessly switchable in-app without the need to restart.

7. **Light & Dark Mode**
   - Dynamically toggles between light and dark themes to enhance user experience.

8. **Unit Testing**
   - Comprehensive test coverage for task CRUD operations, input validation, and state management using mocks.
   -
---

## Screenshots

- OnBoarding - Login Page - Home Page
  ![Screenshot 1](https://i.postimg.cc/xTWQGVdc/Untitled-1.png)

- Light Mode in Arabic - Settings Page - All Tasks
  ![Screenshot 2](https://i.postimg.cc/bwkh3VGL/Untitled-2.png)

- Edit a Task - Add a New Task - SnackBar
  ![Screenshot 3](https://i.postimg.cc/442sd9kv/Untitled-3.png)

---

## Technologies Used

- **Flutter & Dart**: Framework for building cross-platform applications.
- **BLoC**: State management pattern for efficient state handling.
- **SQFLite**: Local database for task storage.
- **SharedPreferences**: Lightweight storage for app settings.
- **Dio**: HTTP client for API integration.
- **Google Material 3**: For UI design and accessibility.

---

## Folder Structure

The project is organized to ensure maintainability and scalability.

``` bash
.
├── assets
│   ├── fonts
│   │   └── Cairo
│   │
│   └── images
│       ├── personal
│       └── splash 
│
├── lib
│   ├── main.dart
│
│   ├── layout
│   │    ├── cubit
│   │    │   ├── cubit.dart
│   │    │   └── states.dart 
│   │    │
│   │    └── home_layout.dart
│   │
│   ├── models
│   ├── modules
│   └── shared
│       ├── components
│       ├── network
│       ├── styles
│       └── bloc_observer.dart
│
├── test
│   ├── cubit_test.dart
│   ├── db_test.dart
│   ├── network_test.dart
│   └── input_validation_test.dart
├── pubspec.yaml
└── README.md

```


---

## Setup Instructions

### Prerequisites
- **Flutter SDK**: Ensure Flutter is installed. [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Included with Flutter.

### Installation

1. Clone the repository; this is my secondary GitHub Account:
   ```bash
   git clone https://github.com/ManuelEcardo/Maids.CC.git
   cd location

2. Install Dependencies:
   ```bash
   flutter pub get

3. Run the application using Android Studio or VS Code:
   ```bash
   flutter run

---

## Design Decisions

- **BLoC** for State Management: Chosen for scalability and separation of concerns.
- **SQLite** for Persistent Storage: Ensures tasks are available offline.
- **Dio:** Simplifies HTTP requests and error handling.
- - **Material 3 Design:** Used for a modern and accessible user interface.
- **Localization** Localization is important for multiple language support.
- **Modes** Light & Dark Mode are enabled to ensure ease of use


---

## Challenges

1. Writing comprehensive unit tests for both online and offline functionality.

2. Following Google Material 3 guidelines


---

## Testing

1. Run Tests via terminal:
   ```bash
   flutter test

---

## Thank You For This Opportunity
# Mohammad Al Bali
