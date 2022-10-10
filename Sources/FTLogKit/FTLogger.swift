import Foundation

// MARK: - Properties

struct FTLogger {
    private let saveToFileLevelOrMoreSevere: LogLevel
    private let logFileURL: URL?
    let logFileHandler: LogFileHandler?
    private var timestampFormatter: DateFormatter

    private static var defaultTimestampFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = .current
        return formatter
    }
}

// MARK: - Constructors

extension FTLogger {
    /// Creates logger which stores log entries also to specified log file
    ///  - throws: May fail to open file.
    init(
        saveToFileLevelOrMoreSevere: LogLevel = .notice,
        logFileURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("logfile.txt"),
        fileManager: FileManager = .default,
        fileCapacity: Double = 2_000.0,
        truncateRelativeThreshold: Double = 1.5,
        timestampFormatter: DateFormatter? = nil
    ) throws {
        self.saveToFileLevelOrMoreSevere = saveToFileLevelOrMoreSevere
        self.logFileURL = logFileURL

        self.timestampFormatter = timestampFormatter ?? Self.defaultTimestampFormatter
        self.logFileHandler = try LogFileHandler(
            fileURL: logFileURL,
            fileManager: { fileManager },
            fileCapacity: fileCapacity,
            thresholdMultiplier: truncateRelativeThreshold
        )
    }

    /// Creates print only logger. No log file is used.
    init(timestampFormatter: DateFormatter? = nil) {
        self.saveToFileLevelOrMoreSevere = .info
        self.logFileURL = nil
        self.logFileHandler = nil

        self.timestampFormatter = timestampFormatter ?? Self.defaultTimestampFormatter
    }
}

// MARK: - Logging logic

extension FTLogger {
    private var timestamp: String {
        timestampFormatter.string(from: Date())
    }

    internal func log(_ entry: LogEntry) {
        let entry = "\(timestamp): \(entry.description)\n"
        print(entry)
        saveToLogFile(entry)
    }

    private func print(_ line: String) {
#if DEBUG
        Swift.print(line)
#endif
    }

    private func saveToLogFile(_ line: String) {
        Task {
            try? await logFileHandler?.write(line)
        }
    }
}

// MARK: - Logging functions

extension FTLogger {
    public func log(
        level: LogLevel,
        _ objects: Any...,
        line: Int = #line,
        file: String = #file,
        function: String = #function
    ) {
        log(LogEntry(objects: objects, logLevel: level, line: line, file: file, functionName: function))
    }

    public func info(
        _ objects: Any...,
        line: Int = #line,
        file: String = #file,
        function: String = #function
    ) {
        log(LogEntry(objects: objects, logLevel: .info, line: line, file: file, functionName: function))
    }

    public func fault(
        _ objects: Any...,
        line: Int = #line,
        file: String = #file,
        function: String = #function
    ) {
        log(LogEntry(objects: objects, logLevel: .fault, line: line, file: file, functionName: function))
    }
}
