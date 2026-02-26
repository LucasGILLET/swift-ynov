import Foundation

struct ExercicesDay3 {

    // --- Exercice 1 ---

    enum ValidationError: Error {
        case invalidEmail
        case weakPassword
        case underage
    }

    static func validateEmail(_ email: String) throws {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        if let _ = try NSRegularExpression(pattern: emailRegex).firstMatch(in: email, range: NSRange(email.startIndex..., in: email)) {
            return
        }
        throw ValidationError.invalidEmail
    }

    static func validatePassword(_ password: String) throws {
        if password.count < 8 {
            throw ValidationError.weakPassword
        }
    }

    static func validateAge(_ age: Int) throws {
        if age < 18 {
            throw ValidationError.underage
        }
    }

    struct User {
        var email: String
        var password: String
        var age: Int

        init(email: String, password: String, age: Int) throws {
            try ExercicesDay3.validateEmail(email)
            try ExercicesDay3.validatePassword(password)
            try ExercicesDay3.validateAge(age)
            self.email = email
            self.password = password
            self.age = age
        }
    }

    func readFile(at path: String) throws -> String {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            throw NSError(domain: "FileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        return try String(contentsOfFile: path, encoding: .utf8)
    }

    func performAsyncOperation(completion: @escaping @Sendable (Result<String, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let success = Bool.random()
            if success {
                completion(.success("Operation successful"))
            } else {
                completion(.failure(NSError(domain: "AsyncError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Operation failed"])))
            }
        }
    }

    // tester les fonctions d'exercice 1

    func testExo1() {
        do {
            let user = try User(email: "test@example.com", password: "password123", age: 25)
            print("User created successfully: \(user)")
        } catch {
            print("Error creating user: \(error)")
        }
        do {
            let content = try readFile(at: "nonexistent.txt")
            print("File content: \(content)")
        } catch {
            print("Error reading file: \(error)")
        }
        performAsyncOperation { result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print("Async operation failed: \(error)")
            }
        }
    }


    // --- Exercice 4 ---
    // Opérations asynchrones pratiques :
    // 1. Faire une fonction async qui simule fetch de données (avec Task.sleep)
    // 2. Fonction qui lance plusieurs fetches en parallèle (async let)
    // 3. Task group pour traiter multiple URLs
    // 4. Gestion d'erreurs avec try/catch async

    func fetchData(from url: String) async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        if Bool.random() {
            return "Data from \(url)"
        } else {
            throw NSError(domain: "FetchError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data from \(url)"])
        }
    }

    func fetchMultipleData() async {
        async let data1 = fetchData(from: "https://api.example.com/data1")
        async let data2 = fetchData(from: "https://api.example.com/data2")
        do {
            let results = try await [data1, data2]
            print("Fetched data: \(results)")
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func fetchDataFromURLs(urls: [String]) async {
        await withTaskGroup(of: String?.self) { group in
            for url in urls {
                group.addTask(operation: {
                    do {
                        return try await self.fetchData(from: url)
                    } catch {
                        print("Error fetching from \(url): \(error)")
                        return nil
                    }
                })
            }
            for await result in group {
                if let result = result {
                    print("Fetched result: \(result)")
                }
            }
        }
    }

    func testExo4() async {
        await fetchMultipleData()
        await fetchDataFromURLs(urls: ["https://api.example.com/data1", "https://api.example.com/data2", "https://api.example.com/data3"])
    }

    
}
