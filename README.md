# 📰 Posts Manager App
### Urugo rw'Amakuru — Rwanda Media Company

> A Flutter mobile application for managing posts using the [JSONPlaceholder](https://jsonplaceholder.typicode.com) REST API. Built as part of **Lab 4 — Consuming APIs in Flutter**.

---

## 🇷🇼 About

This app was developed for **Urugo rw'Amakuru**, a Rwandan media company, to demonstrate full CRUD operations against a REST API in Flutter. The UI is themed with Rwanda's national colors (green & gold) and includes Kinyarwanda labels throughout the interface.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📋 View All Posts | Fetches and displays all posts from the API in a scrollable list |
| 🔍 View Post Details | Tap any post to see its full content on a dedicated screen |
| ➕ Create Post | Submit a new post via a validated form |
| ✏️ Edit Post | Update any existing post's title, body, or user ID |
| 🗑️ Delete Post | Delete a post with a confirmation dialog |
| 🔄 Pull to Refresh | Swipe down on the list to reload all posts |
| ⚠️ Error Handling | Friendly error screens with retry buttons for network failures |

---

## 🗂️ Project Structure

```
posts_manager/
├── pubspec.yaml
└── lib/
    ├── main.dart                      # Entry point + animated splash screen
    ├── theme.dart                     # Rwanda-inspired green/gold app theme
    ├── models/
    │   └── post.dart                  # Post data model (fromJson / toJson)
    ├── services/
    │   └── post_service.dart          # All HTTP calls + ApiException handling
    └── screens/
        ├── posts_list_screen.dart     # Home screen — list of all posts
        ├── post_detail_screen.dart    # Full post view (read + delete)
        └── post_form_screen.dart      # Create & Edit form
```

---

## 🌐 API Reference

**Base URL:** `https://jsonplaceholder.typicode.com`

| Action | Method | Endpoint |
|---|---|---|
| Get all posts | `GET` | `/posts` |
| Get single post | `GET` | `/posts/{id}` |
| Create post | `POST` | `/posts` |
| Update post | `PUT` | `/posts/{id}` |
| Delete post | `DELETE` | `/posts/{id}` |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0          # HTTP requests to the REST API
  cupertino_icons: ^1.0.6
```

### Why `http`?
The `http` package is the official, cross-platform Dart library for making HTTP requests. It provides a clean API for GET, POST, PUT, and DELETE operations with built-in support for headers, request body encoding, and response parsing — everything needed for this lab.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Android emulator or physical device
- Internet connection (app calls a live API)

### Installation

```bash
# 1. Clone or download the project
cd posts_manager

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 🛡️ Error Handling

All API calls are wrapped in try/catch blocks inside `post_service.dart`. The custom `ApiException` class handles:

- **`SocketException`** — No internet / server unreachable → *"Nta interineti"*
- **`FormatException`** — Invalid/malformed JSON response
- **`HTTP 404`** — Post not found
- **`HTTP non-2xx`** — Server-side errors
- **`TimeoutException`** — Requests time out after **15 seconds**
- **Generic catch** — Any unexpected error is safely caught and surfaced

In the UI, `FutureBuilder` drives three states:
1. **Loading** — `CircularProgressIndicator`
2. **Error** — Error message + Retry button
3. **Success** — Full post list / detail

---

## 🎨 Theme & Design

The app uses a custom theme (`theme.dart`) inspired by the **Rwandan flag**:

| Color | Hex | Usage |
|---|---|---|
| Primary Green | `#1A7A4A` | AppBar, buttons, accents |
| Dark Green | `#0D4A2A` | Splash screen background |
| Accent Gold | `#FFD700` | Highlights, badges |
| Light Green | `#E8F5EE` | Card backgrounds |

---

## 📱 Screenshots

> Add screenshots of your running app here.

| Home Screen | Post Detail | Create Post |
|---|---|---|
| *(screenshot)* | *(screenshot)* | *(screenshot)* |

---

## 👨‍💻 Author

**Mbabazi Patrick Straton**  
Lab 4 — Consuming APIs in Flutter  
*Flutter + Dart | JSONPlaceholder API*