<div align="center">

# TextDetection

**基于 Apple Vision 端侧文字识别与 NaturalLanguage 的 IGCSE / A-Level 真题拍照搜答案原型（iOS）。**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-0A84FF.svg)](#运行环境与本地构建)
[![Frameworks](https://img.shields.io/badge/Apple-Vision%20%7C%20NaturalLanguage%20%7C%20SwiftUI-F05138.svg)](#工作原理)

[English](README.md) | **简体中文**

</div>

---

## 项目简介

刷 IGCSE / A-Level 历年真题时反复翻找 PDF 评分标准（Mark Scheme）非常打断节奏。**TextDetection** 是一个完全端侧运行的 iOS SwiftUI 原型：拍下纸质题目，即可离线识别文本并检索对应的评分标准。

## 工作原理

```text
相机拍题 (UIImagePickerController)
        │
        ▼
Apple Vision 端侧 OCR (VNRecognizeTextRequest)
        │
        ▼
NaturalLanguage 本地文本相似度检索
        │
        ▼
本地结构化题库 (paperkey.json) ──► 匹配原题与 Mark Scheme
```

## 项目结构

```text
TextDetection/
├── TextDetectionApp.swift   # SwiftUI 应用入口
├── ContentView.swift        # 相机拍摄封装、Vision OCR 与 NaturalLanguage 检索界面
├── JSONReader.swift         # ExamQuestion 数据结构与 paperkey.json 解析器
└── paperkey.json            # 示例真题题干与评分标准索引数据
```

## 运行环境与本地构建

- **Xcode 15+** 与 **iOS 17+**
- 建议使用 iPhone / iPad 真机运行以调用实时相机拍照（`UIImagePickerController`）

```sh
git clone https://github.com/zs-andy/TextDetection.git
open TextDetection/TextDetection.xcodeproj
```

在 Xcode 中选择设备、配置开发者签名后按 **⌘R** 编译运行。

## 参与贡献

欢迎基于本原型继续扩展：

- **支持相册导入与 VisionKit 实时扫描**：接入相册选图和 `DataScannerViewController`。
- **更强的检索与公式识别**：引入 BM25 / 端侧向量检索，增强数学与理科公式识别。
- **可扩展题库包**：支持导入自定义 JSON / SQLite 题库（CAIE、Edexcel、IB 等考试局）。

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 开源协议

基于 [MIT License](LICENSE) 开源。
