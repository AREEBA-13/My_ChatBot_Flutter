# 🤖 Groq AI ChatBot - Premium Flutter Web Application

An elegant, production-grade AI ChatBot application built with **Flutter Web**, styled dynamically with **VelocityX**, and integrated with the state-of-the-art **Groq Cloud API (Llama 3.3 70B Versatile)** and **Firebase**! 

The application utilizes a secure **Serverless Architecture** featuring isolated, secure multi-user chat sessions, real-time database syncing, and a state-of-the-art **Clean Layered Architecture** folder structure.

🌐 **Live Demo**: [https://areeba-13.github.io/My_ChatBot_Flutter/](https://areeba-13.github.io/My_ChatBot_Flutter/)

---

## 🛠️ The Technology Stack

This application is built with a carefully curated stack of modern web and mobile technologies:

| Layer | Technology | Purpose |
| :--- | :--- | :--- |
| **Frontend Frame** | **Flutter (Web / Desktop)** | High-fidelity, CanvasKit-rendered client application. |
| **Styling & UI** | **VelocityX & Material 3** | Utility-first UI framework enabling responsive layouts & micro-animations. |
| **AI Brain** | **Groq API (Llama 3.3 70B)** | High-speed, high-context AI response completions. |
| **User Identity** | **Firebase Authentication** | Dynamic anonymous authentication to secure each session. |
| **Database** | **Cloud Firestore** | Isolated real-time message streams with Server Timestamps. |
| **Security** | **Firestore Security Rules** | Strict server-side access control for user data. |
| **Local Secrets** | **Flutter Dotenv (`.env`)** | Keeps private API keys out of source control. |
| **Automation** | **GitHub Actions** | Custom CI/CD pipeline with compile-time Dart Defines. |
| **Hosting** | **GitHub Pages** | 100% Free, zero-maintenance global static hosting. |

---

## 📐 Clean Layered Architecture Folder Structure

The code is strictly organized under a domain-driven **Clean Layered Architecture** to maximize code reuse, readability, and scalability:

```
lib/
 ├── 📂 core/
 │    └── 📂 theme/
 │         └── 📄 app_theme.dart        <-- Global Material 3 Themes & color swatches
 ├── 📂 data/
 │    ├── 📂 model/
 │    │    └── 📄 message_model.dart    <-- Data structures & JSON serialization
 │    └── 📂 service/
 │         ├── 📄 groq_service.dart     <-- Groq API Client (Speaks to Groq AI)
 │         └── 📄 firestore_service.dart <-- Live Firestore subcollection controllers
 ├── 📂 presentation/
 │    ├── 📂 screen/
 │    │    └── 📄 chat_screen.dart      <-- Views & real-time StreamBuilders
 │    └── 📂 widget/
 │         ├── 📄 chat_bubble.dart     <-- Custom-styled chat bubbles
 │         ├── 📄 msg_input.dart        <-- Bottom text field & send button
 │         └── 📄 typing_indicator.dart <-- Scaled bouncing dot thinking indicators
 ├── 📄 firebase_options.dart           <-- Consolidated platform credentials
 └── 📄 main.dart                       <-- App Bootstrapper & dynamic Auth session setup
```

---

## ✨ Features & User Experience (UX)

*   🔒 **Multi-User Private Storage**: Dynamic anonymous user sign-in guarantees that users *only* see their own chat history. Data is fully isolated.
*   ⚡ **Dynamic AI Completions**: Speaks directly to Groq's high-speed API with full chronological history context passed automatically.
*   💬 **Advanced UI Elements**:
    *   **Bouncing Dot Thinking Indicator**: Pulse-scaling indicators appear in real-time when the bot is thinking.
    *   **Reversed Auto-Scroll**: Messages flow from bottom-to-top using reversed `ListView` builders with instantaneous real-time sync.
    *   **Zero-Constraint Layouts**: Wrapped inside `Flexible` layout blocks to prevent any right-overflow visual warnings.
*   🛡️ **Ultra-Secure Builds**: No plain-text API keys are ever pushed to GitHub or bundled as public text assets. Private keys are compiled and obfuscated directly inside the JavaScript binary via compile-time Dart Defines.

---

## ⚙️ Local Development Setup

To run this project locally, make sure you have the Flutter SDK installed on your machine.

### 1. Clone the repository:
```bash
git clone https://github.com/AREEBA-13/My_ChatBot_Flutter.git
cd My_ChatBot_Flutter/chat_bot
```

### 2. Configure Your Environment Secrets:
Create a `.env` file at the root of the `chat_bot` directory:
```env
# Groq API Configuration
GROQ_API_KEY=your_actual_groq_api_key_here
```
*(Note: `.env` is automatically added to `.gitignore` to prevent secret leakage).*

### 3. Initialize Firebase options:
Paste your web configuration credentials inside the default `lib/firebase_options.dart` configurations.

### 4. Run the application:
```bash
flutter run
```

---

## 🔒 Firebase Firestore Security Rules

To ensure total isolation of chat histories in production, publish the following rules in your **Firebase Firestore Rules Console**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Restricts read/write access to a user's isolated subcollection only to themselves
    match /users/{userId}/chat_history/{messageId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
  }
}
```

---

## 🚀 CI/CD Automated Zero-Cost Deployment

The project features a fully automated Git deployment pipeline inside `.github/workflows/deploy.yml`. 

Whenever you push to `main`:
1.  Loads a secure `GROQ_API_KEY` from your repository secrets.
2.  Creates a mock empty `.env` asset file to satisfy `pubspec.yaml` bundling requirements.
3.  Injects the active Groq key securely directly into the compiled JavaScript binary using:
    `flutter build web --release --base-href "/My_ChatBot_Flutter/" --dart-define=GROQ_API_KEY=${{ secrets.GROQ_API_KEY }}`
4.  Deploys the static CanvasKit bundle to **GitHub Pages** completely **free of cost**!

---

## 📄 License
Licensed under the [MIT License](LICENSE). Made with ❤️ for educational and open-source project development.
