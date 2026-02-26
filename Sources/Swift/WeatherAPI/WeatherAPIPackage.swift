import Foundation

struct WeatherAPIPackage {
    static func main() async {
        await WeatherAPIManager.shared.run()
    }
}