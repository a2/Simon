public struct Game<T> {
    public private(set) var history: [T]
    var moveGenerator: AnyGenerator<T>

    public init<G: GeneratorType where G.Element == T>(moveGenerator: G, history: [T] = []) {
        self.history = history
        self.moveGenerator = anyGenerator(moveGenerator)
    }

    public mutating func addRound() {
        if let move = moveGenerator.next() {
            history.append(move)
        } else {
            fatalError("moveGenerator yielded unexpected nil value")
        }
    }
}
