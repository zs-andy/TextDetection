<div align="center">

# TextDetection

**On-device iOS OCR & NLP past-paper question scanner and mark-scheme lookup prototype for IGCSE / A-Level exams.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-0A84FF.svg)](#requirements)
[![Frameworks](https://img.shields.io/badge/Apple-Vision%20%7C%20NaturalLanguage%20%7C%20SwiftUI-F05138.svg)](#how-it-works)

**English** | [简体中文](README.zh-CN.md)

</div>

---

## Overview

Flipping through PDF mark schemes while practicing IGCSE and A-Level past papers breaks study flow. **TextDetection** is an offline-first iOS SwiftUI prototype that lets students snap a photo of a printed exam question and immediately look up its corresponding mark scheme on-device.

## How It Works

```text
Camera Capture (UIImagePickerController)
        │
        ▼
Apple Vision OCR (VNRecognizeTextRequest)
        │
        ▼
On-device Text Similarity Matching (NaturalLanguage)
        │
        ▼
Local Question & Mark-Scheme Bank (paperkey.json) ──► Matching Question & Mark Scheme
```

## Project Structure

```text
TextDetection/
├── TextDetectionApp.swift   # SwiftUI app entry point
├── ContentView.swift        # Camera picker, Vision OCR request & NaturalLanguage matching UI
├── JSONReader.swift         # ExamQuestion Codable model & paperkey.json loader
└── paperkey.json            # Sample structured past-paper question & mark-scheme dataset
```

## Requirements & Running Locally

- **Xcode 15+** & **iOS 17+**
- Physical iPhone/iPad recommended for live camera capture (`UIImagePickerController.SourceType.camera`)

```sh
git clone https://github.com/zs-andy/TextDetection.git
open TextDetection/TextDetection.xcodeproj
```

Select your device in Xcode, configure your Signing Team, and press **⌘R**.

## Contributing

Great ways to build on this prototype:

- **Photo Library & VisionKit Live Text**: Support importing photos from the Photo Library and live camera scanning via `DataScannerViewController`.
- **Smarter retrieval**: Add BM25 / embedding search or LaTeX/math OCR support for STEM papers.
- **Extensible paper packs**: Support importing custom JSON/SQLite past-paper banks for more exam boards (CAIE, Edexcel, IB).

See [CONTRIBUTING.md](CONTRIBUTING.md) before opening a PR.

## License

Licensed under the [MIT License](LICENSE).
