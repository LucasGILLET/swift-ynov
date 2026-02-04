import Foundation

struct Movies {

    static func runApp() {
        var shouldQuit = false

        while !shouldQuit {
            displayMenu()
            print("Veuillez entrer votre choix:")
            let choice = Int(readLine() ?? "") ?? 0

            switch choice {
                case 1:
                    print("Afficher tous les films selected")
                    // Option 1 : Affiche tous les films avec displayMovie
                    for movie in Movies.listMovies() {
                        displayMovie((movie.title, movie.year, movie.rating, movie.genre))
                    }
                    break

                case 2:
                    print("Rechercher un film selected")
                    // Option 2 : Demande un titre et recherche le film
                    let title =  readLine()
                    if let title = title, let movie = findMovie(byTitle: title, in: Movies.listMovies()) {
                        displayMovie(movie)
                    } else {
                        print("Movie not found")
                    }

                    break
                case 3:
                    print("Filtrer par genre selected")
                    // Option 3 : Affiche les genres disponibles et filtre
                    let genres = getUniqueGenres(from: Movies.listMovies())
                    print("Available genres: \(genres)")
                    break
                case 4:
                    print("Afficher les statistiques selected")
                    // Option 4 : Affiche nombre total, note moyenne, meilleur film
                    let movies = Movies.listMovies()
                    print("Total movies: \(movies.count)")
                    print("Average rating: \(averageRating(of: movies))")
                    if let best = bestMovie(in: movies) {
                        print("Best movie:")
                        displayMovie(best)
                    }
                    break
                case 5:
                    print("Ajouter un film selected")
                    // Option 5 : Demande les informations et ajoute un film
                    var movies = Movies.listMovies()
                    print("Enter title:")
                    let newTitle = readLine()
                    print("Enter year:")
                    let newYear = readLine()
                    print("Enter rating:")
                    let newRating = readLine()
                    print("Enter genre:")
                    let newGenre = readLine()
                    if let title = newTitle,
                    let yearStr = newYear, let year = Int(yearStr),
                    let ratingStr = newRating, let rating = Double(ratingStr),
                    let genre = newGenre {
                        addMovie(title: title, year: year, rating: rating, genre: genre, to: &movies)
                    } else {
                        print("Invalid input for new movie")
                    }
                    break
                case 6:
                    print("Quitter selected")
                    // Option 6 : Quitte l'application
                    shouldQuit = true
                    break
                default:
                    print("Invalid choice")
            }
        }
    }


    static func listMovies() -> [(title: String, year: Int, rating: Double, genre: String)]{
        let movies: [(title: String, year: Int, rating: Double, genre: String)] = [
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

        return movies;
    }

    static func displayMovie(_ movie: (title: String, year: Int, rating: Double, genre: String))
    {
        print("📽️  \(movie.title) (\(movie.year)) - \(movie.genre)")
        print("⭐ Rating: \(movie.rating)/10")
    }


    static func addMovie(title: String, year: Int, rating: Double, genre: String, to movies: inout [(title: String, year: Int, rating: Double, genre: String)])
    {
        let newMovie: (title: String, year: Int, rating: Double, genre: String) = (title: title, year: year, rating: rating, genre: genre)
        movies.append(newMovie)
        print("Movie '\(title)' added successfully!")
    }

    static func findMovie(byTitle title: String, in movies: [(title: String, year: Int, rating: Double, genre: String)]) -> (title: String, year: Int, rating: Double, genre: String)?
    {
        for movie in movies {
            if movie.title.lowercased() == title.lowercased() {
                return movie
            }
        }
        return nil
    }

    static func filterMovies(_ movies: [(title: String, year: Int, rating: Double, genre: String)], matching criteria: ((title: String, year: Int, rating: Double, genre: String)) -> Bool) -> [(title: String, year: Int, rating: Double, genre: String)]
    {
        var filteredMovies: [(title: String, year: Int, rating: Double, genre: String)] = []
        for movie in movies {
            if criteria(movie) {
                filteredMovies.append(movie)
            }
        }
        return filteredMovies
    }

    static func getUniqueGenres(from movies: [(title: String, year: Int, rating: Double, genre: String)]) -> Set<String>
    {
        var genres: Set<String> = Set()
        for movie in movies {
            genres.insert(movie.genre)
        }
        return genres
    }

    static func averageRating(of movies: [(title: String, year: Int, rating: Double, genre: String)]) -> Double
    {
        guard !movies.isEmpty else {
            return 0.0
        }
        var totalRating: Double = 0.0
        for movie in movies {
            totalRating += movie.rating
        }
        return totalRating / Double(movies.count)
    }

    static func bestMovie(in movies: [(title: String, year: Int, rating: Double, genre: String)]) -> (title: String, year: Int, rating: Double, genre: String)?
    {
        guard !movies.isEmpty else {
            return nil
        }
        var best: (title: String, year: Int, rating: Double, genre: String) = movies[0]
        for movie in movies {
            if movie.rating > best.rating {
                best = movie
            }
        }
        return best
    }

    static func moviesByDecade(_ movies: [(title: String, year: Int, rating: Double, genre: String)]) -> [String: [(title: String, year: Int, rating: Double, genre: String)]]
    {
        var decadeDict: [String: [(title: String, year: Int, rating: Double, genre: String)]] = [:]
        for movie in movies {
            let decade = "\(movie.year / 10 * 10)s"
            if decadeDict[decade] == nil {
                decadeDict[decade] = []
            }
            decadeDict[decade]?.append(movie)
        }
        return decadeDict
    }

    static func displayMenu() {
        print("=== 🎬 Movie Manager ===")
        print("1. Afficher tous les films")
        print("2. Rechercher un film")
        print("3. Filtrer par genre")
        print("4. Afficher les statistiques")
        print("5. Ajouter un film")
        print("6. Quitter")
    }

}
