import Foundation

public final class VirtualFileSystem: ObservableObject {
    @Published public var currentPath: String = "/home"
    private var rootURL: URL

    public init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.rootURL = docs.appendingPathComponent("VirtualRoot")
        setupInitialDirectories()
    }

    private func setupInitialDirectories() {
        let defaultPaths = ["/home", "/Documents", "/Projects", "/Python"]
        for path in defaultPaths {
            let dirURL = rootURL.appendingPathComponent(path)
            try? FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
        }
    }

    public func executeCommand(_ input: String) -> String {
        let components = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        guard let command = components.first, !command.isEmpty else { return "" }
        let args = Array(components.dropFirst())

        switch command {
        case "pwd":
            return currentPath
        case "ls":
            return listDirectory()
        case "cd":
            return changeDirectory(to: args.first ?? "/home")
        case "mkdir":
            return createDirectory(name: args.first)
        default:
            return "Command not found: \(command)"
        }
    }

    private func listDirectory() -> String {
        let targetURL = rootURL.appendingPathComponent(currentPath.dropFirst())
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: targetURL.path) else {
            return "Error reading directory"
        }
        return contents.joined(separator: "\n")
    }

    private func changeDirectory(to path: String) -> String {
        let newURL: URL
        if path.hasPrefix("/") {
            newURL = rootURL.appendingPathComponent(String(path.dropFirst())).standardized
        } else {
            let currentURLPath = rootURL.appendingPathComponent(currentPath.dropFirst())
            newURL = currentURLPath.appendingPathComponent(path).standardized
        }
        
        if newURL.path.hasPrefix(rootURL.path) {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: newURL.path, isDirectory: &isDir), isDir.boolValue {
                let relativePath = String(newURL.path.dropFirst(rootURL.path.count))
                self.currentPath = relativePath.isEmpty ? "/" : relativePath
                return ""
            } else {
                return "cd: no such file or directory: \(path)"
            }
        } else {
            return "cd: permission denied (outside virtual root)"
        }
    }

    private func createDirectory(name: String?) -> String {
        guard let name = name else { return "usage: mkdir <directory>" }
        let currentURLPath = rootURL.appendingPathComponent(currentPath.dropFirst())
        let newURL = currentURLPath.appendingPathComponent(name)
        do {
            try FileManager.default.createDirectory(at: newURL, withIntermediateDirectories: true)
            return ""
        } catch {
            return "mkdir: failed to create \(name)"
        }
    }
}
