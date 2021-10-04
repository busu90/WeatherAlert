import UIKit

class AlertCell: UITableViewCell {
    @IBOutlet private weak var alertImage: AlertImageView!
    @IBOutlet private weak var alertName: UILabel!
    @IBOutlet private weak var alertRange: UILabel!
    @IBOutlet private weak var alertSource: UILabel!

    func setUp(with alert: Alert) {
        alertImage.loadImage(for: alert)
        alertName.text = alert.name
        alertSource.text = alert.senderName
        alertRange.text = "\(DateFormatter.localStringShort.string(from: alert.start)) to \(DateFormatter.localStringShort.string(from: alert.end))"
    }
}
