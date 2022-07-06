@testable import VestiaireHomework
import Quick
import Nimble
import Combine

class WeatherManagerSpec: QuickSpec {
    override func spec() {
        describe("WeatherManager") {
            var subject: RealWeatherManager!
            var mockNetworkManager: MockNetworkManager!
            var subscriptions = Set<AnyCancellable>()
            
            beforeEach {
                mockNetworkManager = .init()
                subject = RealWeatherManager(networkManager: mockNetworkManager)
            }
            
            describe("get forecast") {
                it("succeeds") {
                    var returnedError: Error?
                    var returnedForecast: Forecast?
                    mockNetworkManager.requestStub = .success(Forecast.mock)
                    subject.getWeatherForecast(city: "Paris", days: 10)
                        .sink { completion in
                            switch completion {
                            case let .failure(error):
                                returnedError = error
                            case .finished: break
                            }
                        } receiveValue: { forecast in
                            returnedForecast = forecast
                        }.store(in: &subscriptions)
                    
                    expect(returnedError).to(beNil())
                    expect(returnedForecast).toNot(beNil())
                }
                
                it("fails") {
                    var returnedError: Error?
                    var returnedForecast: Forecast?
                    mockNetworkManager.requestStub = .failure(MockError.anError)
                    subject.getWeatherForecast(city: "Paris", days: 10)
                        .sink { completion in
                            switch completion {
                            case let .failure(error):
                                returnedError = error
                            case .finished: break
                            }
                        } receiveValue: { forecast in
                            returnedForecast = forecast
                        }.store(in: &subscriptions)
                    
                    expect(returnedError).toNot(beNil())
                    expect(returnedForecast).to(beNil())
                }
            }
        }
    }
}
