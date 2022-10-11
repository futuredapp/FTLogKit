public enum LogLevel: Comparable {
    case debug
    case info
    case notice
    case error
    case fault
}

extension LogLevel {
    var emoji: String {
        switch self {
        case .debug:
            return "➡️"
        case .info:
            return "ℹ️"
        case .notice:
            return "📍"
        case .error:
            return "🛑"
        case .fault:
            return "💥"
        }
    }
}
