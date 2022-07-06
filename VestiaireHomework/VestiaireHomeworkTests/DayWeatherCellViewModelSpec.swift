@testable import VestiaireHomework
import Quick
import Nimble
import Combine
import UIKit
import Foundation

class DayWeatherCellViewModelSpec: QuickSpec {
    override func spec() {
        describe("DayWeatherCellViewModel") {
            var subject: DayWeatherCell.ViewModel!
            var measurementUnitService: MeasurementUnitService!
            beforeEach {
                measurementUnitService = RealMeasurementUnitService()
                subject = .init(dayWeather: DayWeather.mock, measurementUnitService: measurementUnitService)
            }
            
            describe("init") {
                it("process data") {
                    expect(subject.sunsetTime).to(equal("Sunset at: " + Date(timeIntervalSince1970: 100).time))
                    expect(subject.sunriseTime).to(equal("Sunrise at: " + Date(timeIntervalSince1970: 100).time))
                    expect(subject.weatherImageUrl).to(equal("https://openweathermap.org/img/w/icon.png"))
                    expect(subject.temperatureType).to(equal(.normal))
                    expect(subject.weatherDescription).to(equal("desc"))
                    expect(subject.humidity).to(equal("Humidity: 10%"))
                    expect(subject.pressure).to(equal("Pressure: 10" + measurementUnitService.pressureSymbol))
                    expect(subject.minTemp).to(equal("L: 10.00" + measurementUnitService.temperatureSymbol))
                    expect(subject.maxTemp).to(equal("H: 10.00" + measurementUnitService.temperatureSymbol))
                }
            }
        }
    }
}
