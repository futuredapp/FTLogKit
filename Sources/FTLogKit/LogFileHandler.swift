import Foundation

actor LogFileHandler {
    private let fileURL: URL
    private let fileManager: () -> FileManager
    private let fileCapacity: Double
    private let thresholdMultiplier: Double

    init(
        fileURL: URL,
        fileManager: @escaping () -> FileManager,
        fileCapacity: Double,
        thresholdMultiplier: Double
    ) throws {
        assert(fileCapacity > 1 && fileCapacity == Double(Int(fileCapacity)), "fileCapacity must be at a positive integer")
        assert(thresholdMultiplier >= 1, "thresholdMultiplier must be higher than 1")
        assert(thresholdMultiplier <= 2, "use higher fileCapacity if you want to store larger files")

        self.fileURL = fileURL
        self.fileManager = fileManager
        self.fileCapacity = fileCapacity
        self.thresholdMultiplier = thresholdMultiplier
    }

    func countLines() throws -> Int {
        guard fileManager().fileExists(atPath: fileURL.path) else {
            return 0
        }
        return try String(contentsOf: fileURL, encoding: .utf8)
            .components(separatedBy: .newlines)
            .dropLast(1)
            .count
    }

    func write(_ entry: String) throws {
        guard let data = entry.data(using: .utf8) else {
            return
        }

        if !fileManager().fileExists(atPath: fileURL.path) {
            try data.write(to: fileURL)
            return
        }

        let fileHandle = try FileHandle(forWritingTo: fileURL)

        if #available(macOS 10.15.4, *) {
            try fileHandle.seekToEnd()
            try fileHandle.write(contentsOf: data)
        } else {
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        }
        try fileHandle.close()
        try truncateLogFileIfNecessary()
    }

    func removeFile() throws {
        do {
            try fileManager().removeItem(at: fileURL)
        } catch {
            Swift.print(error)
            Swift.print(error.localizedDescription)
        }
    }

    func getContents() throws -> String {
        try String(contentsOf: fileURL)
    }

    func truncateLogFileIfNecessary() throws {
        guard Double(try countLines()) > fileCapacity * thresholdMultiplier else {
            return
        }
        let content = try getContents()
            .components(separatedBy: .newlines)
            .dropFirst(Int(fileCapacity * (thresholdMultiplier - 1)))
        try content
            .joined(separator: "\n")
            .write(to: fileURL, atomically: true, encoding: .utf8)
    }
}
