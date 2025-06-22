# 👗 Closet App - AI-Powered Fashion Coordination Assistant

<div align="center">

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0+-green.svg)
![SwiftData](https://img.shields.io/badge/SwiftData-1.0+-purple.svg)
![AI](https://img.shields.io/badge/AI-Gemini%201.5%20Flash-red.svg)

**AI駆動のファッションコーディネートアシスタント**

天気情報とAIを活用して、最適なコーディネートを提案する革新的なiOSアプリ

[![Demo Video](https://img.shields.io/badge/Demo-Video%20Preview-blue?style=for-the-badge&logo=youtube)](https://example.com/demo)
[![App Store](https://img.shields.io/badge/App%20Store-Download-green?style=for-the-badge&logo=app-store)](https://apps.apple.com/app/closet-app)

</div>

## 🚀 特徴

### 🤖 AI-Powered Coordination
- **Google Gemini 1.5 Flash**を活用したインテリジェントなコーディネート提案
- リアルタイム天気情報と組み合わせた最適化アルゴリズム
- 季節・TPO・気温・湿度を考慮した高度な推薦システム

### 🌤️ Weather-Responsive Design
- OpenWeatherMap APIによるリアルタイム天気取得
- 室内外の温度差を考慮した着こなし提案
- 天気予報に基づく事前コーディネート計画

### 📱 Modern iOS Experience
- **SwiftUI 5.0**による最新のUI/UX
- **SwiftData**による高性能ローカルデータ管理
- **Lottie**アニメーションによる豊かな視覚体験
- **Hero**によるスムーズな画面遷移

### 🎨 Advanced UI/UX
- ガラスモーフィズムデザイン
- カスタムタブバーとFABメニュー
- レスポンシブレイアウト
- ダークモード対応

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
- **Smart Recommendations**: 多変量分析による最適化

## 🛠️ 技術スタック

### Core Technologies
- **Swift 5.9** - 最新のSwift言語機能
- **SwiftUI 5.0** - 宣言的UIフレームワーク
- **SwiftData** - モダンなデータ永続化
- **Combine** - リアクティブプログラミング

### AI & External APIs
- **Google Generative AI (Gemini 1.5 Flash)** - インテリジェントなコーディネート提案
- **OpenWeatherMap API** - リアルタイム天気情報
- **Core Location** - 位置情報ベースの天気取得

### UI/UX Libraries
- **Lottie** - 高品質アニメーション
- **Hero** - スムーズな画面遷移
- **Parchment** - タブベースナビゲーション

### Development Tools
- **Xcode 15.0+** - 最新の開発環境
- **SwiftLint** - コード品質管理
- **GitHub Actions** - CI/CD自動化

## 📋 環境要件

### 開発環境
- **Xcode**: 15.0以上
- **iOS Deployment Target**: 17.0以上
- **Swift**: 5.9以上
- **macOS**: 14.0以上 (開発用)

### 実行環境
- **iOS**: 17.0以上
- **デバイス**: iPhone, iPad
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
- **Forecast Planning**: 未来の天気に基づく準備

### 3. Closet Management
- **Smart Categorization**: AIによる自動分類
- **Seasonal Organization**: 季節別アイテム管理
- **TPO Tagging**: シーン別タグ付け

### 4. Advanced UI Features
- **Glass Morphism**: モダンなガラス効果
- **Smooth Animations**: 60fps滑らかなアニメーション
- **Accessibility**: アクセシビリティ対応

## 🤖 AI活用の詳細

### Gemini 1.5 Flash Integration
```swift
// 高度なプロンプトエンジニアリング
struct CoordinatePrompt {
    let userCondition: UserCondition
    let availableCoordinates: [CoordinateDTO]
}

// 多変量分析による最適化
func fetchAndSend(availableCoordinates: [CoordinateDTO], 
                 tpo: String, 
                 season: String) async -> [(UUID, String)]
```

### 機械学習モデル
- **TestModel.mlmodel**: Core ML統合
- **Custom Training**: ユーザーデータによる学習
- **Real-time Inference**: 高速推論

### データ分析
- **Weather Correlation**: 天気とファッションの相関分析
- **User Preference Learning**: ユーザー行動パターン学習
- **Seasonal Trends**: 季節トレンド分析

## 📊 パフォーマンス指標

- **起動時間**: < 2秒
- **AI推論速度**: < 500ms
- **メモリ使用量**: < 100MB
- **バッテリー効率**: 最適化済み

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
- **bugfix/**: バグ修正
- **hotfix/**: 緊急修正
- **release/**: リリース準備

### 開発フロー
1. **develop**ブランチからfeatureブランチを作成
2. 機能開発・テスト完了後、PRを作成
3. コードレビュー後、**develop**にマージ
4. リリース準備完了後、**main**にマージ

### コミットメッセージ規約
```
feat: AI機能の追加
fix: 天気API接続エラーの修正
docs: READMEの更新
style: UIコンポーネントのスタイル調整
refactor: アーキテクチャの改善
test: ユニットテストの追加
```

## 🧪 テスト戦略

### テスト構成
- **Unit Tests**: ビジネスロジック
- **Integration Tests**: API統合
- **UI Tests**: ユーザーインターフェース
- **Performance Tests**: パフォーマンス検証

### AI テスト
- **Prompt Testing**: プロンプト品質検証
- **Response Validation**: AI応答の妥当性確認
- **Fallback Testing**: エラー時の代替処理

## 📈 開発ロードマップ

### v1.1.0 (Q1 2024)
- [ ] より高度なAI推奨アルゴリズム
- [ ] ユーザー行動分析の強化
- [ ] パフォーマンス最適化

### v1.2.0 (Q2 2024)
- [ ] ソーシャル機能の追加
- [ ] クラウド同期
- [ ] 複数デバイス対応

### v2.0.0 (Q3 2024)
- [ ] AR試着機能
- [ ] 音声アシスタント
- [ ] 高級ブランド連携

## 🤝 コントリビューション

### 開発者向けガイドライン
1. **Fork** リポジトリ
2. **Feature branch** を作成 (`git checkout -b feature/AmazingFeature`)
3. **Commit** 変更 (`git commit -m 'Add some AmazingFeature'`)
4. **Push** ブランチ (`git push origin feature/AmazingFeature`)
5. **Pull Request** を作成

### コード品質
- **SwiftLint** ルールの遵守
- **SwiftFormat** による自動フォーマット
- **Documentation** の充実

## 📄 ライセンス

このプロジェクトは **MIT License** の下で公開されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## 🙏 謝辞

- **Google Gemini Team** - 革新的なAI技術の提供
- **OpenWeatherMap** - 信頼性の高い天気データ
- **SwiftUI Community** - 素晴らしいUIフレームワーク

## 📞 サポート

- **Issues**: [GitHub Issues](https://github.com/yourusername/closet-app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/closet-app/discussions)
- **Email**: support@closet-app.com

---

<div align="center">

**Made with ❤️ and AI by the Closet App Team**

[![GitHub stars](https://img.shields.io/github/stars/yourusername/closet-app?style=social)](https://github.com/yourusername/closet-app)
[![GitHub forks](https://img.shields.io/github/forks/yourusername/closet-app?style=social)](https://github.com/yourusername/closet-app)
[![GitHub issues](https://img.shields.io/github/issues/yourusername/closet-app)](https://github.com/yourusername/closet-app/issues)

</div>
