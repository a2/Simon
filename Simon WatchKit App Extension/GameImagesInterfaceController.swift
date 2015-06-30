import SimonKit
import WatchKit

class GameImagesInterfaceController: WKInterfaceController {
    var game: Game<Color>!

    // MARK: - IBOutlets 

    @IBOutlet weak var redImage: WKInterfaceImage!
    @IBOutlet weak var greenImage: WKInterfaceImage!
    @IBOutlet weak var yellowImage: WKInterfaceImage!
    @IBOutlet weak var blueImage: WKInterfaceImage!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!

    // MARK: - Life Cycle

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        let box = context as! Box<Game<Color>>
        game = box.value
    }
}
