import Foundation

struct HighScore {
    let score: Int
    let date: NSDate

    init(score: Int, date: NSDate) {
        self.score = score
        self.date = date
    }
}

extension HighScore: RawRepresentable {
    init?(rawValue: [String : AnyObject]) {
        if let score = rawValue["score"] as? Int, date = rawValue["date"] as? NSDate {
            self.init(score: score, date: date)
        } else {
            return nil
        }
    }

    var rawValue: [String : AnyObject] {
        return [
            "score": score,
            "date": date,
        ]
    }
}

extension HighScore: Equatable {}

func ==(lhs: HighScore, rhs: HighScore) -> Bool {
    return lhs.score == rhs.score && abs(lhs.date.timeIntervalSinceDate(rhs.date)) < 1
}

extension HighScore: Comparable {}

func <(lhs: HighScore, rhs: HighScore) -> Bool {
    if lhs.score < rhs.score {
        return true
    } else if lhs.score > rhs.score {
        return false
    } else {
        return lhs.date.compare(rhs.date) == .OrderedAscending
    }
}
