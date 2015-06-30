import Darwin.C.stdlib

extension Color: RandomValuable {
    public static func random() -> Color {
        switch arc4random_uniform(4) {
        case 0: return .Red
        case 1: return .Green
        case 2: return .Yellow
        case 3: return .Blue
        default:
            fatalError("arc4random_uniform(4) expected to return element in 0..<4")
        }
    }
}
