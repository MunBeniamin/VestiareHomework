import Foundation
import UIKit
import Combine

var asyncImagesCashArray = NSCache<NSString, UIImage>()

class AsyncImageView: UIImageView {

    private var currentURL: NSString?
    let networkManager: NetworkManager
    
    var subscriptions = Set<AnyCancellable>()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(image: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAsyncFrom(url: String, placeholder: UIImage?) {
        let imageURL = url as NSString
        if let cashedImage = asyncImagesCashArray.object(forKey: imageURL) {
            image = cashedImage
            return
        }
        image = placeholder
        currentURL = imageURL
        guard let requestURL = URL(string: url) else { image = placeholder; return }

        networkManager.getImage(url: requestURL)
            .receive(on: DispatchQueue.main)
            .sink { image in
                if let image = image {
                    asyncImagesCashArray.setObject(image, forKey: imageURL)
                    self.image = image
                } else {
                    self.image = placeholder
                }
            }.store(in: &subscriptions)
    }
}
