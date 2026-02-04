import Foundation

struct Movies {

    typealias Movie = (title: String, year: Int, rating: Double, genre: String)
    
    @MainActor static var list: [Movie] = [
        (title: "Inception", year: 2010, rating: 8.8, genre: "Sci-Fi"),
        (title: "Interstellar", year: 2014, rating: 8.6, genre: "Sci-Fi"),
        (title: "The Dark Knight", year: 2008, rating: 9.0, genre: "Action"),
        (title: "Pulp Fiction", year: 1994, rating: 8.9, genre: "Crime"),
        (title: "Fight Club", year: 1999, rating: 8.8, genre: "Drama"),
        (title: "Forrest Gump", year: 1994, rating: 8.8, genre: "Drama"),
        (title: "The Lord of the Rings: The Return of the King", year: 2003, rating: 8.9, genre: "Fantasy"),
        (title: "The Shawshank Redemption", year: 1994, rating: 9.3, genre: "Drama"),
        (title: "The Godfather", year: 1972, rating: 9.2, genre: "Crime"),
        (title: "The Dark Knight Rises", year: 2012, rating: 8.4, genre: "Action")
    ]
    
    @MainActor static func runApp() {
        var shouldQuit = false

        while !shouldQuit {
            displayMenu()
            print("Veuillez entrer votre choix:")
            let choice = Int(readLine() ?? "") ?? 0

            switch choice {
                case 1:
                    for movie in list {
                        displayMovie(movie)
                    }
                    break

                case 2:
                    let title =  readLine()
                    if let title = title, let movie = findMovie(byTitle: title, in: list) {
                        displayMovie(movie)
                    } else {
                        print("Movie not found")
                    }

                    break
                case 3:
                    let genres = getUniqueGenres(from: list)
                    print("Available genres: \(genres)")
                    break
                case 4:
                    let movies = list
                    print("Total movies: \(movies.count)")
                    print("Average rating: \(averageRating(of: movies))")
                    if let best = bestMovie(in: movies) {
                        print("Best movie:")
                        displayMovie(best)
                    }
                    break
                case 5:
                    print("Enter title:")
                    let newTitle = readLine()
                    print("Enter year:")
                    let newYear = readLine()
                    print("Enter rating:")
                    let newRating = readLine()
                    print("Enter genre:")
                    let newGenre = readLine()
                    if let title = newTitle,
                        let yearStr = newYear, 
                        let year = Int(yearStr),
                        let ratingStr = newRating, 
                        let rating = Double(ratingStr),
                        let genre = newGenre {
                            addMovie(title: title, year: year, rating: rating, genre: genre, to: &list)
                    } else {
                        print("Invalid input for new movie")
                    }
                    break
                case 6:
                    shouldQuit = true
                    break
                default:
                    print("Invalid choice")
            }
        }
    }

    static func displayMovie(_ movie: Movie)
    {
        print("📽️  \(movie.title) (\(movie.year)) - \(movie.genre) ||| ⭐ Rating: \(movie.rating)/10")
    }


    static func addMovie(title: String, year: Int, rating: Double, genre: String, to movies: inout [Movie])
    {
        let newMovie: Movie = (title: title, year: year, rating: rating, genre: genre)
        movies.append(newMovie)
        print("Movie '\(title)' added successfully!")
    }

    static func findMovie(byTitle title: String, in movies: [Movie]) -> Movie?
    {
        return movies.first { $0.title.lowercased() == title.lowercased() }
    }

    static func filterMovies(_ movies: [Movie], matching criteria: (Movie) -> Bool) -> [Movie]
    {
        return movies.filter(criteria)
    }

    static func getUniqueGenres(from movies: [Movie]) -> Set<String>
    {
        return Set(movies.map { $0.genre })
    }

    static func averageRating(of movies: [Movie]) -> Double
    {
        guard !movies.isEmpty else { return 0.0 }
        let totalRating = movies.reduce(0.0) { $0 + $1.rating }
        return totalRating / Double(movies.count)
    }

    static func bestMovie(in movies: [Movie]) -> Movie?
    {
        return movies.max { $0.rating < $1.rating }
    }

    static func moviesByDecade(_ movies: [Movie]) -> [String: [Movie]]
    {
        return Dictionary(grouping: movies) { "\(($0.year / 10) * 10)s" }
    }

    static func displayMenu() {
        print("=== 🎬 Movie Manager ===")
        let options = [
            "Afficher tous les films",
            "Rechercher un film",
            "Filtrer par genre",
            "Afficher les statistiques",
            "Ajouter un film",
            "Quitter"
        ]
        options.enumerated().forEach { print("\($0.offset + 1). \($0.element)") }
    }

}
