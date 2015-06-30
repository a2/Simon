import WatchKit

class GameImagesInterfaceController: WKInterfaceController {
    @IBOutlet weak var redImage: WKInterfaceImage!
    @IBOutlet weak var greenImage: WKInterfaceImage!
    @IBOutlet weak var yellowImage: WKInterfaceImage!
    @IBOutlet weak var blueImage: WKInterfaceImage!

    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
}
