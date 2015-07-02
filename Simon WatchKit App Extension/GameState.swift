import SimonKit

struct GameState<T> {
    let guess: [T]
    let game: Game<T>

    init(game: Game<T>, guess: [T]) {
        self.game = game
        self.guess = []
    }
}
