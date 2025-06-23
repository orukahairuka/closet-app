# 👗 Closet App - AI-Powered Fashion Coordination Assistant

**朝、時間がないあなたのために！迷わず服を選べるiOSアプリ**

天気と室内の気温をもとに、AIが最適なコーディネートを提案。  
あなたのクローゼットをもっと便利に。

</div>

# **_🧪TestFlight_**

- **URL👉** : [GitHub TestFlight](https://testflight.apple.com/join/RdwWqy6U)
<br><br>
  
  



## 🚀 特徴

### 🤖 AI-Powered Coordination
- **Google Gemini 1.5 Flash**を活用したインテリジェントなコーディネート提案
- リアルタイム天気情報と組み合わせた最適化アルゴリズム
- 季節・TPO・気温・湿度を考慮した服の組み合わせ提案

### 🌤️ Weather-Responsive Design
- 室内外の温度差を考慮した着こなし提案

### 📱 Modern iOS Experience
- **SwiftUI 5.0**による最新のUI/UX
- **SwiftData**による高性能ローカルデータ管理
- **Lottie**アニメーションによる豊かな視覚体験
- **Hero**によるスムーズな画面遷移

## 🏗️ アーキテクチャ

### Clean Architecture + MVVM
```
closet-app/
├── Presentation/          # UI Layer
│   ├── View/             # SwiftUI Views
│   ├── ViewModel/        # MVVM ViewModels
│   └── Component/        # Reusable Components
├── Domain/               # Business Logic Layer
│   ├── Entity/           # Data Models
│   ├── UseCase/          # Business Use Cases
│   ├── Repository/       # Data Access Interface
│   └── Protocol/         # Protocol Definitions
└── Data/                 # Data Layer (implied)
```

### AI Integration Architecture
- **CoordinateAIManager**: Gemini API統合
- **Weather Integration**: リアルタイム天気データ

### AI & External APIs
- **Google Gemini 1.5 Flash API** - 服装アドバイス & コーデ提案

### UI/UX Libraries
- **Lottie** - 高品質アニメーション
- **Hero** - スムーズな画面遷移
- **Parchment** - タブベースナビゲーション

## 📋 環境要件

### 開発環境
- **Xcode**: 16.4以上
- **iOS Deployment Target**: 17.0以上
- **Swift**: 5.9以上
- **macOS**: 14.0以上 (開発用)

### 実行環境
- **iOS**: 17.0以上
- **デバイス**: iPhone
- **容量**: 最小50MB

## 🚀 セットアップ手順

### 1. リポジトリのクローン
```bash
git clone https://github.com/yourusername/closet-app.git
cd closet-app
```

### 2. 依存関係のインストール
```bash
# Xcodeでプロジェクトを開く
open closet-app.xcodeproj
```

### 3. API キーの設定
```swift
// Domain/Entity/APIKey.swift を編集
struct APIKey {
    static let default = "YOUR_GEMINI_API_KEY"
    static let weather = "YOUR_OPENWEATHER_API_KEY"
}
```

### 4. ビルド & 実行
```bash
# Xcodeでビルド
⌘ + R
```

## 🎯 主要機能

### 1. AI-Powered Coordination
- **Smart Matching**: 天気・季節・TPOを考慮した最適化
- **Personalized Recommendations**: ユーザーの好み学習
- **Real-time Updates**: 天気変化に応じた動的提案

### 2. Weather Integration
- **Live Weather Data**: リアルタイム天気情報
- **Indoor/Outdoor Analysis**: 温度差を考慮した提案

### 3. Closet Management
- **Smart Categorization**: AIによる自動分類
- **Seasonal Organization**: 季節別アイテム管理
- **TPO Tagging**: シーン別タグ付け

### 4. Advanced UI Features
- **Glass Morphism**: モダンなガラス効果

## 🔄 ブランチ運用ルール

### ブランチ構成
```
main
├── develop
│   ├── feature/ai-enhancement
│   ├── feature/weather-integration
│   ├── feature/ui-improvements
│   └── feature/performance-optimization
├── hotfix/critical-bug-fix
└── release/v1.0.0
```

### ブランチ命名規則
- **feature/**: 新機能開発
- **fix/**: バグ修正
- **hotfix/**: 緊急修正

### 開発フロー
1. **dev**ブランチからfeatureブランチを作成
2. 機能開発・テスト完了後、PRを作成
3. コードレビュー後、**dev**にマージ
4. リリース準備完了後、**main**にマージ

### 謝辞
このアプリは京都産業大学情報理工学部デジタル制作・研究共創チャレンジプログラムの支援を受けたものである
