import Foundation
import SimonKit
import WatchKit

let HighScoresKey = "HighScores"
let MaxHighScoresCount = 10

class MainMenuInterfaceController: WKInterfaceController {
    let userDefaults = NSUserDefaults(suiteName: "group.us.pandamonia.Simon")!
    var highScores: [HighScore] {
        get {
            let rawValues = userDefaults.arrayForKey(HighScoresKey) as? [[String : AnyObject]]
            return rawValues?.flatMap(HighScore.init).sort() ?? []
        }
        set {
            let object = newValue.map { $0.rawValue }
            userDefaults.setObject(object, forKey: HighScoresKey)
        }
    }
    
    // MARK: - IBOutlets

    @IBOutlet weak var gameOverGroup: WKInterfaceGroup!
    @IBOutlet weak var gameOverText: WKInterfaceLabel!
    @IBOutlet weak var highScoreLabel: WKInterfaceLabel!

    // MARK: - Actions

    @IBAction func play() {
        WKInterfaceController.reloadRootControllersWithNames(["game"], contexts: nil)
    }

    @IBAction func showHighScores() {
        let segueName = highScores.count > 0 ? "highScores" : "emptyHighScores"
        pushControllerWithName(segueName, context: Box(highScores))
    }

    // MARK: - Life Cycle

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        if userDefaults.objectForKey(GameHistoryKey) != nil {
            play()
            return
        }

        if let score = context as? Int {
            var newHighScores = highScores
            newHighScores.append(HighScore(score: score, date: NSDate()))
            newHighScores.sortInPlace()
            if newHighScores.count > MaxHighScoresCount {
                newHighScores.removeRange(MaxHighScoresCount..<newHighScores.count)
            }
            highScores = newHighScores

            gameOverText.setText(String.localizedStringWithFormat(NSLocalizedString("You survived for %d rounds! Better luck next time.", comment: "Game over text; {count} is replaced with the number of rounds completed"), score))
            gameOverGroup.setHidden(false)
        } else {
            gameOverGroup.setHidden(true)
        }

        if let highScore = highScores.first {
            highScoreLabel.setHidden(false)
            highScoreLabel.setText(String.localizedStringWithFormat(NSLocalizedString("High Score: %d", comment: "High score label; {score} is replaced with the high score"), highScore.score))
        } else {
            highScoreLabel.setHidden(true)
        }
    }
}
