import Foundation

extension FTLogger {
    // swiftlint:disable:next force_try
    public static let shared: FTLogger = try! FTLogger(
        saveToFileLevelOrMoreSevere: .debug,
        logFileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("logfile.txt")
    )

    public static func log(
        level: LogLevel,
        _ objects: Any...,
        line: Int = #line,
        file: String = #file,
        function: String = #function
    ) {
        shared.log(level: level, objects, line: line, file: file, function: function)
    }

    public static func info(
        _ objects: Any...,
        line: Int = #line,
        file: String = #file,
        function: String = #function
    ) {
        shared.info(objects, line: line, file: file, function: function)
    }

    public static func fault(
        _ objects: Any...,
        line: Int = #line,
        file: String = #file,
        function: String = #function
    ) {
        shared.fault(objects, line: line, file: file, function: function)
    }

    public static func getLogs() async throws -> String {
        try await shared.logFileHandler?.getContents() ?? ""
    }
}
