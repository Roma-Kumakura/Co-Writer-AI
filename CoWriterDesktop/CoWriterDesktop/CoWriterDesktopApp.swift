//
//  CoWriterDesktopApp.swift
//  CoWriterDesktop
//
//  Created by 熊倉羅馬 on 23/07/2025.
//

import SwiftUI
import AVFoundation

@main
struct CoWriterDesktopApp: App {
    
    // ここが初期化メソッド（アプリ起動時に一度だけ呼ばれる）
    init() {
        // macOS でマイク権限をリクエスト
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("✅ マイク権限 OK")
            } else {
                print("❌ マイク権限が拒否されました")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
