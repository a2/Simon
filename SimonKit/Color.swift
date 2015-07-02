public enum Color: Int {
    case Red
    case Green
    case Yellow
    case Blue
}

extension Color: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Red:
            return "Red"
        case .Green:
            return "Green"
        case .Yellow:
            return "Yellow"
        case .Blue:
            return "Blue"
        }
    }
}
