@testable import VestiaireHomework
import UIKit
import Combine

class MockNetworkManager: NetworkManager {
    
    var requestStub: Result<Any, Error> = .failure(MockError.anError)
    
    func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> {
        requestStub
            .publisher
            .map { $0 as! T }
            .eraseToAnyPublisher()
    }
    
    var getImageResult: PassthroughSubject<UIImage?, Never> = .init()
    func getImage(url: URL) -> AnyPublisher<UIImage?, Never> {
        getImageResult.eraseToAnyPublisher()
    }
}
