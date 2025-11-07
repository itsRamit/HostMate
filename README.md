# HostMate

HostMate is a **Flutter-based onboarding experience** designed for **Hotspot Hosts** to showcase their intent, interests, and motivation through a seamless, media-rich journey.

The app implements a **two-step onboarding flow**:
1. **Experience Selection Screen**
2. **Onboarding Question Screen**

It is built with a focus on **pixel-perfect design**, **smooth animations**, and **scalable state management**.

---

## 🚀 Core Features

### 🧩 1. Experience Selection Screen
A visually engaging experience selection interface with dynamic interactivity.

#### ✳️ Implemented Features
- **Interactive Card Selection/Deselection**
  - Tap to select or deselect individual experience cards.
  - Multiple card selection supported.
- **Grayscale Unselected State**
  - Unselected cards appear in grayscale.
  - Selected cards restore full-color display.
- **Image-based Cards**
  - Each experience card displays its `image_url` as the background.
- **Multi-line TextField (250 chars)**
  - Users can input additional details, with a live character counter.
- **State Management with Riverpod**
  - Stores selected experience IDs and text state globally.
- **Next Button Functionality**
  - Logs selected data and navigates to the next screen.

#### 💅 Brownie Points & Enhancements
- **Card Raise Animation (Stamp Effect)**
  - On card selection, it animates upwards slightly, creating a tactile, engaging feel.
- **Card Slide Animation**
  - Selected card slides to the top of the list for better visibility.
- **Pixel-perfect UI**
  - Matched all spacings, font styles, and color palette from Figma.
- **Responsive Layout**
  - Adapts to various device sizes and maintains balance when keyboard appears.

---

### 🎤 2. Onboarding Question Screen
Collects the host’s intent using text, audio, and video inputs with real-time feedback.

#### ✳️ Implemented Features
- **Multi-line TextField (600 chars)**
  - For descriptive responses.
- **Audio Recording with Waveform**
  - Uses `audio_waveforms` for a live, dynamic waveform.
  - Options to start, stop, cancel, and delete recordings.
- **Video Recording Support**
  - Record responses directly in-app.
  - Option to delete recorded video.
- **Smart Layout**
  - Automatically hides audio/video buttons once a recording is saved.
- **Responsive UI**
  - Adjusts layout dynamically when keyboard or camera preview is active.

#### 💅 Brownie Points & Enhancements
- **Animated “Next” Button**
  - When recording ends, the Next button smoothly expands to full width.
- **Dynamic Visual States**
  - UI updates instantly on recording state changes.
- **Pixel-Perfect Design**
  - Strict adherence to Figma for padding, typography, and color precision.
- **State Management**
  - All state handled using **Flutter Riverpod (v3)**.
- **Scalable Architecture**
  - Independent reusable widgets:
    - `RecordingBar`
    - `VideoRecordingPreview`
    - `VideoPlaybackCard`
    - `StepperBar`
- **Dio Integration Ready**
  - Prepared for backend integration and API calls using `Dio`.

---

## 🧠 State Management
- Implemented using **Riverpod 3.0.3**
- Tracks:
  - Selected experience IDs
  - Text input
  - Audio/Video recording states
- Centralized provider ensures global state consistency and easy debugging.

---

## 🛠️ Tech Stack & Dependencies

| Category | Package | Version |
|-----------|----------|----------|
| **Networking** | dio | ^5.9.0 |
| **State Management** | flutter_riverpod | ^3.0.3 |
| **Image Caching** | cached_network_image | ^3.4.1 |
| **Audio Recording** | flutter_sound | ^9.2.13 |
| **Waveform Visualization** | audio_waveforms | ^1.3.0 |
| **Permissions** | permission_handler | ^12.0.1 |
| **Camera/Video** | camera | ^0.11.3 |
| **Local Storage** | path_provider | ^2.1.5 |
| **Video Playback** | video_player | ^2.10.0 |
| **Video Thumbnails** | video_thumbnail | ^0.5.6 |

---

## 🎨 UI & UX Highlights
- Fully responsive design for all device sizes.
- Smooth transitions and animations.
- Minimalist design with clear spacing hierarchy.
- Elegant use of gradients, rounded corners, and subtle shadows.
- Dynamic button transformations enhance user interaction feedback.

---

## 🏅 Brownie Points Implemented
✅ Pixel-perfect design from Figma  
✅ Card slide and raise (stamp) animation on selection  
✅ Animated button transitions on recording stop  
✅ Riverpod-based state management  
✅ Dio setup for API calls  
✅ Responsive keyboard-safe layouts  
✅ Modular architecture with reusable widgets  

