@testable import VestiaireHomework
import Quick
import Nimble
import Combine

class WeatherViewControllerViewModelSpec: QuickSpec {
    override func spec() {
        describe("WeatherViewControllerViewModel") {
            var subject: WeatherViewController.ViewModel!
            var weatherManagerMock: MockWeatherManager!
            var subscriptions = Set<AnyCancellable>()
            beforeEach {
                weatherManagerMock = MockWeatherManager()
                subject = .init(weatherManager: weatherManagerMock)
            }
            
            describe("getForecastFor") {
                it("succeeds") {
                    subject.getForecastFor(city: "Paris", days: 10)
                    
                    subject.forecast
                        .dropFirst()
                        .sink { forecast in
                            expect(subject.forecast.value).toNot(beNil())
                        }.store(in: &subscriptions)
                }
            }
        }
    }
}
