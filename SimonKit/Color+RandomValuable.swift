import Darwin.C.stdlib

extension Color: RandomValuable {
    public static func random() -> Color {
        let rawValue: Int = numericCast(arc4random_uniform(4))
        return Color(rawValue: rawValue)!
    }
}
