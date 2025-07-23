import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var log = "Ready.\n"
    @State private var isRecording = false
    @State private var proc: Process?
    
    var body: some View {
        VStack(spacing: 20) {
            Button(isRecording ? "録音停止" : "録音開始") {
                isRecording ? stopRecording() : startRecording()
            }
            .padding()
            .background(isRecording ? .red : .blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            ScrollView {
                Text(log)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .font(.system(size: 12, design: .monospaced))
            }
            .border(.gray)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }
    
    // MARK: - 録音開始
    private func startRecording() {
        isRecording = true
        log += "▶️ 録音開始 (5 秒)\n"
        
        let projectDir = "/Users/kumakuraroma/Desktop/co-writer"
        let python     = "\(projectDir)/.venv310/bin/python"          // 3.10 venv
        let script     = "\(projectDir)/scripts/record_and_pitch.py"
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.arguments = [
            "-c",
            "cd \(projectDir) && \(python) \(script) --seconds 5"
        ]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError  = pipe
        pipe.fileHandleForReading.readabilityHandler = { h in
            if let line = String(data: h.availableData, encoding: .utf8),
               !line.isEmpty {
                DispatchQueue.main.async { self.log += line }
            }
        }
        
        do {
            try task.run()
            proc = task
        } catch {
            isRecording = false
            log += "❌ 起動失敗: \(error)\n"
        }
        
        task.terminationHandler = { _ in
            DispatchQueue.main.async {
                self.isRecording = false
                self.proc = nil
                self.log += "✅ 終了 code=\(task.terminationStatus)\n"
            }
        }
    }
    
    // MARK: - 録音停止
    private func stopRecording() {
        guard let t = proc else { return }
        log += "⏹️ 停止要求\n"
        t.terminate()
    }
}

#Preview { ContentView() }

