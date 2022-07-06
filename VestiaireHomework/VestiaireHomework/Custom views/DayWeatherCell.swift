import UIKit
import SnapKit

class DayWeatherCell: UITableViewCell {
    let dayLabel = UILabel()
    let weatherImageView = AsyncImageView(networkManager: DIContainer.current.networkManager)
    let weatherDescriptionLabel = UILabel()
    let sunriseLabel = UILabel()
    let sunsetLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let pressureLabel = UILabel()
    let humidityLabel = UILabel()
    let leftIconView = UIImageView(image: nil)
    let containerView = UIView()
    
    init(viewModel: ViewModel) {
        self.dayLabel.text = viewModel.dayName
        self.weatherImageView.loadAsyncFrom(url: viewModel.weatherImageUrl,
                                            placeholder: nil)
        self.weatherDescriptionLabel.text = viewModel.weatherDescription
        self.sunriseLabel.text = viewModel.sunriseTime
        self.sunsetLabel.text = viewModel.sunsetTime
        self.minTempLabel.text = viewModel.minTemp
        self.maxTempLabel.text = viewModel.maxTemp
        self.pressureLabel.text = viewModel.pressure
        self.humidityLabel.text = viewModel.humidity
        self.leftIconView.image = viewModel.temperatureType.image
        self.leftIconView.tintColor = viewModel.temperatureType.tint
        self.containerView.layer.cornerRadius = Sizing.medium
        self.containerView.backgroundColor = .white
        
        super.init(style: .default, reuseIdentifier: nil)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(dayLabel)
        containerView.addSubview(weatherImageView)
        containerView.addSubview(weatherDescriptionLabel)
        containerView.addSubview(sunriseLabel)
        containerView.addSubview(sunsetLabel)
        containerView.addSubview(minTempLabel)
        containerView.addSubview(maxTempLabel)
        containerView.addSubview(pressureLabel)
        containerView.addSubview(humidityLabel)
        containerView.addSubview(leftIconView)
        
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DayWeatherCell {
    func applyLayout() {
        contentView.layoutMargins = UIEdgeInsets(top: Sizing.small,
                                                 left: Sizing.medium,
                                                 bottom: Sizing.small,
                                                 right: Sizing.medium)
        
        containerView.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalTo(contentView.layoutMarginsGuide)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Sizing.medium)
            make.width.equalTo(50)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel.snp.centerY)
            make.leading.equalTo(dayLabel.snp.trailing).offset(Sizing.small)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Sizing.medium)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(Sizing.small)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Sizing.medium)
            make.leading.equalTo(minTempLabel.snp.trailing).offset(Sizing.small)
        }
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(Sizing.small)
            make.leading.trailing.equalToSuperview().offset(Sizing.medium)


        }
        
        sunriseLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(Sizing.small)
            make.leading.equalToSuperview().offset(Sizing.medium)

        }
        
        sunsetLabel.snp.makeConstraints { make in
            make.top.equalTo(sunriseLabel.snp.bottom).offset(Sizing.small)
            make.leading.equalToSuperview().offset(Sizing.medium)

        }
        
        pressureLabel.snp.makeConstraints { make in
            make.top.equalTo(sunsetLabel.snp.bottom).offset(Sizing.small)
            make.leading.equalToSuperview().offset(Sizing.medium)

        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(pressureLabel.snp.bottom).offset(Sizing.small)
            make.leading.equalToSuperview().offset(Sizing.medium)
            make.bottom.equalToSuperview().inset(Sizing.medium)
        }
        
        leftIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Sizing.medium)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
}

extension DayWeatherCell {
    class ViewModel {
        var dayName: String = ""
        var weatherImageUrl: String = ""
        var weatherDescription: String = ""
        var sunriseTime: String = ""
        var sunsetTime: String = ""
        var minTemp: String = ""
        var maxTemp: String = ""
        var pressure: String = ""
        var humidity: String = ""
        var temperatureType: TemperatureType = .normal
        
        let dayWeather: DayWeather
        let measurementUnitService: MeasurementUnitService
        
        init(dayWeather: DayWeather, measurementUnitService: MeasurementUnitService) {
            self.dayWeather = dayWeather
            self.measurementUnitService = measurementUnitService
            
            dayName = Date(timeIntervalSince1970: dayWeather.dt).dayName
            weatherImageUrl = "https://openweathermap.org/img/w/" + (dayWeather.weather.first?.icon ?? "") + ".png"
            weatherDescription = dayWeather.weather.first?.description ?? ""
            sunriseTime = "Sunrise at: " + Date(timeIntervalSince1970: dayWeather.sunrise).time
            sunsetTime = "Sunset at: " + Date(timeIntervalSince1970: dayWeather.sunset).time
            minTemp = "L: " + measurementUnitService.displayTemperature(dayWeather.temp.min, from: .celsius, decimalPlaces: 2) + measurementUnitService.temperatureSymbol
            maxTemp = "H: " + measurementUnitService.displayTemperature(dayWeather.temp.max, from: .celsius, decimalPlaces: 2) + measurementUnitService.temperatureSymbol
            pressure = "Pressure: \(dayWeather.pressure)" + measurementUnitService.pressureSymbol
            humidity = "Humidity: \(dayWeather.humidity)%"
            temperatureType = TemperatureType.from(temp: dayWeather.temp.max)
        }
    }
}


enum TemperatureType {
    case normal
    case hot
    case cold
    
    var image: UIImage? {
        switch self {
        case .normal: return nil
        case .hot: return UIImage(systemName: "flame.fill")?.withRenderingMode(.alwaysTemplate)
        case .cold: return UIImage(systemName: "snowflake")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var tint: UIColor {
        switch self {
        case .normal: return .clear
        case .hot: return .red
        case .cold: return .blue
        }
    }
    
    static func from(temp: Double) -> TemperatureType {
        if temp > 25 {
            return .hot
        }
        
        if temp < 10 {
            return .cold
        }
        
        return .normal
    }
}
