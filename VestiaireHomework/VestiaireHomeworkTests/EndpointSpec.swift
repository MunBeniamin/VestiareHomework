@testable import VestiaireHomework
import Quick
import Nimble

class EndpointSpec: QuickSpec {
    override func spec() {
        describe("EndPoint") {
            describe("forecast request") {
                it("returns the correct endpoint") {
                    let subject = Endpoint.forecast(city: "Paris", units: .metric, days: 10)
                    expect(subject.url.absoluteString).to(equal("https://api.openweathermap.org/data/2.5/forecast/daily?q=Paris&mode=json&units=metric&cnt=10&appid=648a3aac37935e5b45e09727df728ac2"))
                }
            }
        }
    }
}
