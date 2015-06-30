import SimonKit
import WatchKit

class GameButtonsInterfaceController: WKInterfaceController {
    var game: Game<Color>!

    // MARK: - IBOutlets

    @IBOutlet weak var redButton: WKInterfaceButton!
    @IBOutlet weak var greenButton: WKInterfaceButton!
    @IBOutlet weak var yellowButton: WKInterfaceButton!
    @IBOutlet weak var blueButton: WKInterfaceButton!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!

    // MARK: - Life Cycle

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        let box = context as! Box<Game<Color>>
        game = box.value
    }
}
