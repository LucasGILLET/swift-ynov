// TP3 - Weather Data Aggregator
// Async Fetching Functions

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// HELPER: Wrapper cross-platform pour URLSession (fourni)
// Cette fonction fonctionne sur macOS, Linux et Windows
@available(macOS 10.15, *)
func fetchData(from url: URL) async throws -> (Data, URLResponse) {
#if os(macOS)
    if #available(macOS 12.0, *) {
        return try await URLSession.shared.data(from: url)
    }
#endif
    
    return try await withCheckedThrowingContinuation { continuation in
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                continuation.resume(throwing: error)
                return
            }
            guard let data = data, let response = response else {
                continuation.resume(throwing: URLError(.badServerResponse))
                return
            }
            continuation.resume(returning: (data, response))
        }
        task.resume()
    }
}

// 4. FETCH FUNCTIONS (8 pts)

// TODO 4.1: Fonction buildWeatherURL(latitude:longitude:) -> URL? (1 pt)
// URL: https://api.open-meteo.com/v1/forecast?latitude=XX&longitude=YY&current_weather=true

func buildWeatherURL(latitude: Double, longitude: Double) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.open-meteo.com"
    components.path = "/v1/forecast"
    components.queryItems = [
        URLQueryItem(name: "latitude", value: String(latitude)),
        URLQueryItem(name: "longitude", value: String(longitude)),
        URLQueryItem(name: "current_weather", value: "true")
    ]
    return components.url
}

// TODO 4.2: Fonction async fetchWeather(for city: City) throws -> CurrentWeather (3 pts)
// - Construire l'URL
// - Utiliser fetchData(from: url) pour obtenir (data, response)
// - Vérifier code HTTP 200-299
// - JSONDecoder().decode(WeatherResponse.self, from: data)
// - Retourner currentWeather
func fetchWeather(for city: City) async throws -> CurrentWeather {
    guard let url = buildWeatherURL(latitude: city.latitude, longitude: city.longitude) else {
        throw WeatherError.invalidURL
    }
    
    do {
        let (data, response) = try await fetchData(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw WeatherError.networkError("HTTP error: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        }
        
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
        return weatherResponse.currentWeather
    } catch let error as DecodingError {
        throw WeatherError.decodingError("Decoding error: \(error.localizedDescription)")
    } catch {
        throw WeatherError.networkError("Network error: \(error.localizedDescription)")
    }
}

// TODO 4.3: Fonction async fetchMultipleCities(cities, cache) -> [(City, Result<CurrentWeather, Error>)] (4 pts)
// - withTaskGroup
// - Pour chaque ville: group.addTask { ... }
// - Vérifier cache avant fetch
// - Mettre en cache après fetch réussi
// - Collecter tous les résultats avec for await

func fetchMultipleCities(_ cities: [City], cache: WeatherCache) async -> [(City, Result<CurrentWeather, Error>)] {
    var results: [(City, Result<CurrentWeather, Error>)] = []
    
    await withTaskGroup(of: (City, Result<CurrentWeather, Error>).self) { group in
        for city in cities {
            group.addTask {
                if let cachedWeather = await cache.get(city.name) {
                    return (city, .success(cachedWeather))
                }
                
                do {
                    let weather = try await fetchWeather(for: city)
                    await cache.set(weather, for: city.name)
                    return (city, .success(weather))
                } catch {
                    return (city, .failure(error))
                }
            }
        }
        
        for await result in group {
            results.append(result)
        }
    }
    
    return results
}