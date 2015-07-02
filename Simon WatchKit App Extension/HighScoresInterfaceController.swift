import Foundation
import WatchKit

class HighScoresInterfaceController: WKInterfaceController {
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter
    }()

    var scores: [HighScore]!

    // MARK: - IBOutlets

    @IBOutlet weak var table: WKInterfaceTable!

    // MARK: View Life Cycle

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        let box = context as! Box<[HighScore]>
        scores = box.value

        table.setNumberOfRows(scores.count, withRowType: "highScore")

        for (i, highScore) in scores.enumerate() {
            let rowController = table.rowControllerAtIndex(i) as! HighScoreController

            rowController.scoreLabel.setText(String.localizedStringWithFormat(NSLocalizedString("%d pts.", comment: "Score in points; {score} is replaced with the number of completed rounds"), highScore.score))
            rowController.dateLabel.setText(dateFormatter.stringFromDate(highScore.date))
        }
    }
}
