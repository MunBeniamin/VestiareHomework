@testable import VestiaireHomework
import Quick
import Nimble

class UnitSystemSpec: QuickSpec {
    override func spec() {
        describe("UnitSystem") {
            describe("unitTemperature") {
                it("returns the correct unit") {
                    expect(UnitSystem.metric.unitTemperature).to(equal(.celsius))
                    expect(UnitSystem.imperial.unitTemperature).to(equal(.fahrenheit))
                    expect(UnitSystem.metric.unitPressure).to(equal(.millibars))
                    expect(UnitSystem.imperial.unitPressure).to(equal(.millibars))
                }
            }
        }
    }
}
