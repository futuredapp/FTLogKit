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
            return "âĄī¸"
        case .info:
            return "âšī¸"
        case .notice:
            return "đ"
        case .error:
            return "đ"
        case .fault:
            return "đĨ"
        }
    }
}
