struct DIContainer {
    static var current: DIContainer = .init()
    
    let weatherManager: WeatherManager
    let networkManager: NetworkManager
    let measurementUnitService: MeasurementUnitService
    var unitSystem: UnitSystem = .metric
    
    init(weatherManager: WeatherManager,
         networkManager: NetworkManager,
         measurementUnitService: MeasurementUnitService) {
        self.weatherManager = weatherManager
        self.networkManager = networkManager
        self.measurementUnitService = measurementUnitService
    }
    
    init() {
        networkManager = RealNetworkManager()
        weatherManager = RealWeatherManager(networkManager: networkManager)
        measurementUnitService = RealMeasurementUnitService(locale: .current)
    }
}
