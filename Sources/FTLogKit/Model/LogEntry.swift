struct LogEntry {
    let objects: [Any]
    let logLevel: LogLevel
    let line: Int
    let file: String
    let functionName: String
}

extension LogEntry {
    internal var description: String {
        let filename = file.components(separatedBy: "/").last ?? ""
        let message = "[\(logLevel.emoji)] \(filename):\(line) \(functionName): "
        return objects.reduce(into: message) { message, object in
            print(object, terminator: " ", to: &message)
        }
    }
}
