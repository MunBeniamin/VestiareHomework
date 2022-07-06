import UIKit
import Combine

class WeatherViewController: UITableViewController {

    private var viewModel: ViewModel
    var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.title = "16 days Forecast"
        tableView.separatorStyle = .none
        setupForecastListener()
        setupNavigationBar()
        viewModel.getForecastFor(city: "Paris", days: 16)
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unit System", style: .plain, target: self, action: #selector(unitSystemTapped))
    }
    
    @objc func unitSystemTapped() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 100)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        
        let index: Int = UnitSystem.allCases.firstIndex(of: viewModel.diContainer.unitSystem) ?? 0
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
        let unitSystemAlert = UIAlertController(title: "Choose unit system", message: "", preferredStyle: .alert)
        unitSystemAlert.setValue(vc, forKey: "contentViewController")
        unitSystemAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(unitSystemAlert, animated: true)
    }
    
    func setupForecastListener() {
        viewModel.forecast.sink { [unowned self] forecast in
            self.tableView.reloadData()
        }.store(in: &subscriptions)
    }
}

extension WeatherViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UnitSystem.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let unitSystem = UnitSystem.allCases[row]
        viewModel.diContainer.unitSystem = unitSystem
        tableView.reloadData()
    }
}

extension WeatherViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        UnitSystem.allCases.count
    }
}

extension WeatherViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.forecast.value?.list.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dayWeather = viewModel.forecast.value?.list[indexPath.row] else {
            return UITableViewCell()
        }
        
        return DayWeatherCell(viewModel: DayWeatherCell.ViewModel(dayWeather: dayWeather, measurementUnitService: viewModel.diContainer.measurementUnitService))
    }
}

extension WeatherViewController {
    class ViewModel {
        let forecast = CurrentValueSubject<Forecast?, Never>(nil)
        private let weatherManager: WeatherManager
        var subscriptions = Set<AnyCancellable>()
        var diContainer = DIContainer.current
        
        init(weatherManager: WeatherManager) {
            self.weatherManager = weatherManager
        }
        
        func getForecastFor(city: String, units: UnitSystem = .metric, days: Int) {
            weatherManager.getWeatherForecast(city: city, units: units, days: days)
                .receive(on: DispatchQueue.main)
                .sink {  completion in
                    switch completion {
                    case let .failure(error):
                        print("Get forecast for \(city) failed with error: \(error)")
                    case .finished: break
                    }
                } receiveValue: { [weak self] forecast in
                    guard let self = self else { return }
                    
                    self.forecast.send(forecast)
                }
                .store(in: &subscriptions)

        }
    }
}
