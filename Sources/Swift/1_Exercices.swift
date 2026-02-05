import Foundation

struct Exercices {

    static func workWithStuddents() {
        print("Finally, let's work with arrays !")
        let students: [(String, Int)] = [("Alice", 12), ("Bob", 15), ("Charlie", 14), ("Diana", 13), ("Ethan", 16)]
        let averageNote: Double = calculateAverageGrade(students: students)
        print("The average grade of the students is: \(averageNote)")
        let bestStudent: (String, Int) = findBestStudent(students: students)
        print("The best student is \(bestStudent.0) with a grade of \(bestStudent.1)")

        let dictionnary: [String: Int] = ["Alice": 12, "Bob": 15, "Charlie": 14, "Diana": 13, "Ethan": 16]
        let studentsWithMoreThan12: [String] = findStudentsWithGradeAbove(dictionnary: dictionnary, grade: 12)
        print("Students with a grade above 12: \(studentsWithMoreThan12)")
    }

    static func findStudentsWithGradeAbove(dictionnary: [String: Int], grade: Int) -> [String] {
        var studentsAboveGrade: [String] = []
        for (student, studentGrade) in dictionnary {
            if studentGrade > grade {
                studentsAboveGrade.append(student)
            }
        }
        return studentsAboveGrade
    }

    static func findBestStudent(students: [(String, Int)]) -> (String, Int) {
        var bestStudent: (String, Int) = ("", 0)
        for student in students {
            if student.1 > bestStudent.1 {
                bestStudent = student
            }
        }
        return bestStudent
    }

    static func calculateAverageGrade(students: [(String, Int)]) -> Double {
        var total: Int = 0
        for student in students {
            total += student.1
        }
        return Double(total) / Double(students.count)
    }

    static func playWithNumber() {
        print("Donnez moi un nombre")
        let input: String? = readLine()
        guard let input: String = input, let inputAsInt: Int = Int(input) else {
            print("Entrée invalide")
            return
        }

        switch inputAsInt {
            case let x where x % 2 == 0:
            print("\(x) is even")
            case let x where x % 2 != 0:
            print("\(x) is odd")
            default:
            break
        } 

        print("Voici les multiples de 3 jusqu'à \(inputAsInt):")
        for i: Int in 0...inputAsInt {
            if i % 3 == 0 {
                print(i)
            }
        }
    }

    static func profile() {
        let name: String = "Dupont"
        let age: Int = 25
        let height: Double = 1.75
        
        let middleName: String? = "Jean"
        
        let currentYear: Int = 2026
        let birthYear: Int = currentYear - age
        
        print("=== Profile ===")
        print("Name: \(name)")
        print("Age: \(age) years old")
        print("Height: \(height) meters")
        print("Birth year: \(birthYear)")

        if let middleName: String = middleName {
            print("Middle name: \(middleName)")
        }
    }
}
