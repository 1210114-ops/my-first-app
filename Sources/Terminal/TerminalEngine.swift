import Foundation
import SwiftUI

public final class TerminalEngine: ObservableObject {
    @Published public var output: String = "Welcome to AI Terminal Pro\n$ "
    @Published public var inputBuffer: String = ""
    private let parser = ANSIParser()
    
    public init() {}
    
    public func executeCommand(_ command: String) {
        inputBuffer = ""
        output += command + "\n"
        
        let trimmed = command.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            output += "Processing command: \(trimmed)\n"
        }
        output += "$ "
    }
}

public struct TerminalView: View {
    @EnvironmentObject var terminalEngine: TerminalEngine
    @EnvironmentObject var fileSystem: VirtualFileSystem
    @State private var scrollPosition: CGFloat = 0
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Text(terminalEngine.output)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.green)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.black.opacity(0.9))
            
            HStack {
                Text("$ ")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.green)
                
                TextField("", text: $terminalEngine.inputBuffer)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.green)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        let cmd = fileSystem.executeCommand(terminalEngine.inputBuffer)
                        terminalEngine.executeCommand(terminalEngine.inputBuffer)
                        if !cmd.isEmpty {
                            terminalEngine.output += cmd + "\n"
                        }
                    }
            }
            .padding()
            .background(Color.black.opacity(0.95))
        }
        .background(Color.black)
    }
}

public struct CodeEditorView: View {
    @EnvironmentObject var fileSystem: VirtualFileSystem
    
    public var body: some View {
        VStack {
            Text("File System: \(fileSystem.currentPath)")
                .font(.headline)
            
            Text("Virtual filesystem initialized")
                .padding()
            
            Spacer()
        }
    }
}
