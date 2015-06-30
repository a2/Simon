public struct Game<T> {
    var history: [T]
    var moveGenerator: AnyGenerator<T>

    public init<G: GeneratorType where G.Element == T>(moveGenerator: G, history: [T] = []) {
        self.history = history
        self.moveGenerator = anyGenerator(moveGenerator)
    }
}
