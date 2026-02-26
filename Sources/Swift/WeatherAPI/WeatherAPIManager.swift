// TP3 - Weather Data Aggregator
// Main Manager

import Foundation


final class WeatherAPIManager: Sendable {
    static let shared = WeatherAPIManager()
    private init() {}

    func run() async {
        print("=== Weather Data Aggregator ===\n")

        // TODO 5.1: Créer array de 10 villes (1 pt)
        // Exemples: Paris (48.8566, 2.3522), London (51.5074, -0.1278), etc.
        let cities = [
            City(name: "Paris", latitude: 48.8566, longitude: 2.3522),
            City(name: "London", latitude: 51.5074, longitude: -0.1278),
            City(name: "Tokyo", latitude: 35.6762, longitude: 139.6503),
            City(name: "New York", latitude: 40.7128, longitude: -74.0060),
            City(name: "Sydney", latitude: -33.8688, longitude: 151.2093),
            City(name: "Berlin", latitude: 52.5200, longitude: 13.4050),
            City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
            City(name: "Dubai", latitude: 25.2048, longitude: 55.2708),
            City(name: "São Paulo", latitude: -23.5505, longitude: -46.6333),
            City(name: "Mumbai", latitude: 19.0760, longitude: 72.8777)
        ]

        // TODO 5.2: Créer WeatherCache + mesurer temps (1 pt)
        let cache = WeatherCache()
        let startTime = Date().timeIntervalSince1970

        // TODO 5.3: Appeler fetchMultipleCities et afficher résultats (2 pts)
        // ✓ Paris: 12.3°C, Wind: 15.2 km/h
        // ✗ London: Error - ...

        let results = await fetchMultipleCities(cities, cache: cache)
        for (city, result) in results {
            switch result {
            case .success(let weather):
                print("✓ \(city.name): \(weather.temperature)°C, Wind: \(weather.windSpeed) km/h")
            case .failure(let error):
                print("✗ \(city.name): Error - \(error)")
            }
        }

        // TODO 5.4: Calculer et afficher statistiques (3 pts)
        // - Total/Success/Failed
        // - Température avg/min/max
        // - Cache hits/misses/hit rate
        // - Temps d'exécution

        let stats = await cache.getStats()
        let endTime = Date().timeIntervalSince1970
        let executionTime = endTime - startTime

        let successfulItems = results.compactMap { (city, result) -> (City, CurrentWeather)? in
            if case .success(let weather) = result {
                return (city, weather)
            }
            return nil
        }

        let failedCount = results.count - successfulItems.count

        print("\n=== Statistics ===")
        print("Total cities: \(results.count)")
        print("Successful: \(successfulItems.count)")
        print("Failed: \(failedCount)")

        if !successfulItems.isEmpty {
            let temperatures = successfulItems.map { $0.1.temperature }
            let avgTemp = temperatures.reduce(0, +) / Double(temperatures.count)
            
            let warmest = successfulItems.max { $0.1.temperature < $1.1.temperature }
            let coldest = successfulItems.min { $0.1.temperature < $1.1.temperature }
            
            print("Average temperature: \(String(format: "%.1f", avgTemp))°C")
            if let warmest = warmest {
                print("Warmest: \(warmest.0.name) at \(warmest.1.temperature)°C")
            }
            if let coldest = coldest {
                print("Coldest: \(coldest.0.name) at \(coldest.1.temperature)°C")
            }
        }

        print("\n=== Cache Statistics ===")
        print("Cache hits: \(stats.hits)")
        print("Cache misses: \(stats.misses)")
        if stats.total > 0 {
            print("Hit rate: \(String(format: "%.1f", Double(stats.hits) / Double(stats.total) * 100))%")
        }

        print("\nExecution time: \(String(format: "%.2f", executionTime))s")
        // BONUS: Deuxième fetch pour tester le cache (+2 pts)
        print("\n=== Second Fetch (Testing Cache) ===")
        let secondResults = await fetchMultipleCities(cities, cache: cache)
        for (city, result) in secondResults {
            switch result {
            case .success(let weather):
                print("✓ \(city.name): \(weather.temperature)°C, Wind: \(weather.windSpeed) km/h")
            case .failure(let error):
                print("✗ \(city.name): Error - \(error)")
            }
        }

        let finalStats = await cache.getStats()
        print("\n=== Cache Statistics (After Second Fetch) ===")
        print("Cache hits: \(finalStats.hits)")
        print("Cache misses: \(finalStats.misses)")
        if finalStats.total > 0 {
            print("Hit rate: \(String(format: "%.1f", Double(finalStats.hits) / Double(finalStats.total) * 100))%")
        }
    }
}