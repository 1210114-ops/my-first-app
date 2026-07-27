import Foundation

public struct ANSISegment {
    public let text: String
    public let colorCode: Int
}

public class ANSIParser {
    public init() {}
    
    public func parse(_ input: String) -> [ANSISegment] {
        let pattern = "\\u001B\\[[0-9;]*m"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return [ANSISegment(text: input, colorCode: 0)]
        }
        
        var segments: [ANSISegment] = []
        var currentColor = 0
        var lastIndex = input.startIndex
        
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        for match in matches {
            if let range = Range(match.range, in: input) {
                if lastIndex < range.lowerBound {
                    let text = String(input[lastIndex..<range.lowerBound])
                    segments.append(ANSISegment(text: text, colorCode: currentColor))
                }
                
                let codeString = String(input[range]).dropFirst(2).dropLast()
                currentColor = Int(codeString.components(separatedBy: ";").first ?? "0") ?? 0
                lastIndex = range.upperBound
            }
        }
        
        if lastIndex < input.endIndex {
            let text = String(input[lastIndex...])
            segments.append(ANSISegment(text: text, colorCode: currentColor))
        }
        
        return segments.isEmpty ? [ANSISegment(text: input, colorCode: 0)] : segments
    }
}
