extension Game where T: RandomValuable {
    public init(history: [T] = []) {
        let generator = anyGenerator { T.random() }
        self.init(moveGenerator: generator, history: history)
    }
}
