import Foundation
import UIKit

class AlertDetailsViewController: UIViewController {
    @IBOutlet private weak var alertImage: AlertImageView!
    @IBOutlet private weak var alertRange: UILabel!
    @IBOutlet private weak var alertSeverity: UILabel!
    @IBOutlet private weak var alertCertanty: UILabel!
    @IBOutlet private weak var alertUrgency: UILabel!
    @IBOutlet private weak var alertSource: UILabel!
    @IBOutlet private weak var alertDescription: UILabel!
    @IBOutlet private weak var alertZones: UILabel!
    @IBOutlet private weak var alertInstructions: UILabel!

    private var initialTapLocation: CGPoint = .zero

    var alert: Alert!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = alert.name

        alertImage.loadImage(for: alert)
        alertImage.isUserInteractionEnabled = true
        alertRange.text = "\(DateFormatter.localStringShort.string(from: alert.start)) to \(DateFormatter.localStringShort.string(from: alert.end))"
        alertSeverity.text = alert.severity
        alertCertanty.text = alert.certainty
        alertUrgency.text = alert.urgency
        alertSource.text = alert.senderName
        alertDescription.text = alert.description
        alertDescription.isUserInteractionEnabled = true
        alertInstructions.text = alert.instruction
        alertInstructions.isUserInteractionEnabled = true
        alertZones.text = alert.affectedZones.map({ $0.split(separator: "/").last ?? "" }).joined(separator: ", ")

        alertDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(descriptionTap)))
        alertInstructions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instructionsTap)))
        alertImage.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(imageLongPress(gesture:))))
        alertImage.superview?.bringSubviewToFront(alertImage)
    }

    @objc private func descriptionTap() {
        toggleExpanded(for: alertDescription)
    }

    @objc private func instructionsTap() {
        toggleExpanded(for: alertInstructions)
    }

    @objc private func imageLongPress(gesture: UILongPressGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        if gesture.state == .began {
            initialTapLocation = gesture.location(in: self.view)
        } else if gesture.state == .changed {
            let location = gesture.location(in: self.view)
            view.transform = CGAffineTransform(translationX: location.x - initialTapLocation.x, y: location.y - initialTapLocation.y)
        } else if gesture.state == .ended  || gesture.state == .cancelled {
            view.transform = .identity
        }
    }

    private func toggleExpanded(for view: UILabel) {
        view.numberOfLines = view.numberOfLines == 0 ? 2 : 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
