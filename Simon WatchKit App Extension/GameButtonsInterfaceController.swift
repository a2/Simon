import WatchKit

class GameButtonsInterfaceController: WKInterfaceController {
    @IBOutlet weak var redButton: WKInterfaceButton!
    @IBOutlet weak var greenButton: WKInterfaceButton!
    @IBOutlet weak var yellowButton: WKInterfaceButton!
    @IBOutlet weak var blueButton: WKInterfaceButton!

    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
}
