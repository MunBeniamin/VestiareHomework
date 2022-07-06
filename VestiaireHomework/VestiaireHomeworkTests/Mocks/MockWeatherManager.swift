@testable import VestiaireHomework
import UIKit
import Combine

class MockWeatherManager: WeatherManager {
    var getImageResult: PassthroughSubject<Forecast, Error> = .init()
    func getWeatherForecast(city: String, units: UnitSystem, days: Int) -> AnyPublisher<Forecast, Error> {
        getImageResult.eraseToAnyPublisher()
    }
}
