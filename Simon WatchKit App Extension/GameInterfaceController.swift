import SimonKit
import WatchKit
import UIKit

let GameHistoryKey = "GameHistoryKey"
@asmname("UIAccessibilityPostNotification") func UIAccessibilityPostNotification(notification: UIAccessibilityNotifications, argument: AnyObject?)

class GameInterfaceController: WKInterfaceController {
    let userDefaults = NSUserDefaults(suiteName: "group.us.pandamonia.Simon")!

    var game = Game<Color>()
    var guess = [Color]()

    // MARK: - IBOutlets

    @IBOutlet weak var redImage: WKInterfaceImage!
    @IBOutlet weak var redButton: WKInterfaceButton!

    @IBOutlet weak var greenImage: WKInterfaceImage!
    @IBOutlet weak var greenButton: WKInterfaceButton!

    @IBOutlet weak var yellowImage: WKInterfaceImage!
    @IBOutlet weak var yellowButton: WKInterfaceButton!

    @IBOutlet weak var blueImage: WKInterfaceImage!
    @IBOutlet weak var blueButton: WKInterfaceButton!

    @IBOutlet weak var scoreLabel: WKInterfaceLabel!

    // MARK: - Actions

    func colorButtonTapped(color: Color) {
        guess.append(color)

        // Validate
        let isValid: Bool = {
            for (c1, c2) in zip(guess, game.history[0..<guess.count]) {
                if c1 != c2 {
                    return false
                }
            }

            return true
        }()

        if !isValid {
            // Game over
            userDefaults.removeObjectForKey(GameHistoryKey)
            userDefaults.synchronize()

            WKInterfaceController.reloadRootControllers([("mainMenu", game.history.count - 1)])
        } else if guess.count == game.history.count {
            updatePoints(game.history.count)
            disableAllButtons()

            guess.removeAll(keepCapacity: true)
            game.addRound()

            let when = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(when, dispatch_get_main_queue(), playHistory)
        }
    }

    func updatePoints(score: Int) {
        let pointsText = String.localizedStringWithFormat(NSLocalizedString("%d pts.", comment: "Score in points; {score} is replaced with the number of completed rounds"), score)
        scoreLabel.setText(String.localizedStringWithFormat(NSLocalizedString("Score: %@", comment: "Score label; text; {score} is replaced with the number of completed rounds"), pointsText))
    }

    @IBAction func redButtonTapped() {
        colorButtonTapped(.Red)
    }

    @IBAction func greenButtonTapped() {
        colorButtonTapped(.Green)
    }

    @IBAction func yellowButtonTapped() {
        colorButtonTapped(.Yellow)
    }

    @IBAction func blueButtonTapped() {
        colorButtonTapped(.Blue)
    }

    // MARK: - Playback

    func enableAllButtons() {
        for button in [redButton, greenButton, yellowButton, blueButton] {
            button.setEnabled(true)
        }
    }

    func flashImage(color: Color) {
        func animate(image: WKInterfaceImage) {
            image.startAnimatingWithImagesInRange(NSRange(1..<11), duration: 0.5, repeatCount: 1)
        }

        let localizedAnnouncement: String
        switch color {
        case .Red:
            localizedAnnouncement = NSLocalizedString("Red", comment: "Accessibility announcement; red")
            redImage.setImageNamed("Red")
            animate(redImage)
        case .Green:
            localizedAnnouncement = NSLocalizedString("Green", comment: "Accessibility announcement; green")
            greenImage.setImageNamed("Green")
            animate(greenImage)
        case .Yellow:
            localizedAnnouncement = NSLocalizedString("Yellow", comment: "Accessibility announcement; yellow")
            yellowImage.setImageNamed("Yellow")
            animate(yellowImage)
        case .Blue:
            localizedAnnouncement = NSLocalizedString("Blue", comment: "Accessibility announcement; blue")
            blueImage.setImageNamed("Blue")
            animate(blueImage)
        }

        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, argument: localizedAnnouncement)
        WKInterfaceDevice.currentDevice().playHaptic(.Click)
    }

    func disableAllButtons() {
        for button in [redButton, greenButton, yellowButton, blueButton] {
            button.setEnabled(false)
        }
    }

    func playHistory() {
        disableAllButtons()

        for (i, color) in game.history.enumerate() {
            let when = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(i) * NSEC_PER_SEC))
            dispatch_after(when, dispatch_get_main_queue()) {
                self.flashImage(color)
            }
        }

        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(game.history.count - 1) * NSEC_PER_SEC + NSEC_PER_SEC / 2))
        dispatch_after(when, dispatch_get_main_queue(), enableAllButtons)
    }

    // MARK: - Life Cycle

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()

        if let gameHistory = userDefaults.arrayForKey(GameHistoryKey) as? [Int] {
            game = Game(history: gameHistory.flatMap(Color.init))
        }

        updatePoints(game.history.count)

        if game.history.count == 0 {
            game.addRound()
        }

        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(when, dispatch_get_main_queue(), playHistory)
    }

    override func didDeactivate() {
        super.didDeactivate()

        let object = game.history.map { $0.rawValue }
        userDefaults.setObject(object, forKey: GameHistoryKey)
        userDefaults.synchronize()
    }
}
