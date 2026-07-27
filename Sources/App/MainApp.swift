import SwiftUI
import Foundation

@main
struct AITerminalProApp: App {
    @StateObject private var fileSystem = VirtualFileSystem()
    @StateObject private var terminalEngine = TerminalEngine()
    @StateObject private var aiEngine = AIEngine()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fileSystem)
                .environmentObject(terminalEngine)
                .environmentObject(aiEngine)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            TerminalView()
                .tabItem { Label("Terminal", systemImage: "terminal") }
            
            CodeEditorView()
                .tabItem { Label("Files", systemImage: "doc.text") }
            
            VStack {
                Text("AI Assistant")
            }
            .tabItem { Label("AI", systemImage: "sparkles") }
        }
    }
}
