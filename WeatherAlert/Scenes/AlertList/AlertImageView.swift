import Foundation
import UIKit

class AlertImageView: UIImageView {
    private static let imageCache = NSCache<NSURL, UIImage>()
    private let activity = UIActivityIndicatorView(style: .medium)
    private var downloadTask: URLSessionDataTask?

    func loadImage(for alert: Alert) {
        downloadTask?.cancel()
        activity.removeFromSuperview()
        image = nil
        guard let url = alert.image ?? URL(string: "https://picsum.photos/1000") else { return }
        if let cached = AlertImageView.imageCache.object(forKey: url as NSURL) {
            image = cached
            return
        }

        addSubview(activity)
        activity.center = center
        activity.startAnimating()

        downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                self?.activity.removeFromSuperview()
                alert.image = response?.url
                guard let data = data, let image = UIImage(data: data) else { return }
                AlertImageView.imageCache.setObject(image, forKey: (response?.url ?? url) as NSURL)
                self?.image = image
            }
        }
        downloadTask?.resume()
    }
}
