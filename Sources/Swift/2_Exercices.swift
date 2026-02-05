import Foundation

struct ExercicesDay2 {

    // --- Exercice 1 ---
    struct Point2D {
        var x: Double
        var y: Double
    }

    struct Rectangle {
        var origin: Point2D
        var width: Double
        var height: Double
        
        func area() -> Double {
            return width * height
        }

        func perimeter() -> Double {
            return 2 * (width + height)
        }

        func contains(point: Point2D) -> Bool {
            let withinX = point.x >= origin.x && point.x <= origin.x + width
            let withinY = point.y >= origin.y && point.y <= origin.y + height
            return withinX && withinY
        }

        mutating func move(dx: Double, dy: Double) {
            origin.x += dx
            origin.y += dy
        }
    }

    func testRectangle() {
        var rect = Rectangle(origin: Point2D(x: 0, y: 0), width: 4, height: 2)
        print("Area: \(rect.area())")
        print("Perimeter: \(rect.perimeter())")
        
        let point1 = Point2D(x: 1, y: 1)
        let point2 = Point2D(x: 5, y: 1)
        print("Contains point1: \(rect.contains(point: point1))")
        print("Contains point2: \(rect.contains(point: point2))")
        
        rect.move(dx: 2, dy: 3)
        print("New origin after moving: (\(rect.origin.x), \(rect.origin.y))")
    }

    // --- Exercice 2 ---

    class Shape {
        var name: String

        init(name: String) {
            self.name = name
        }

        func area() -> Double {
            return 0
        }
    }

    class Circle: Shape {
        var radius: Double

        init(radius: Double) {
            self.radius = radius
            super.init(name: "Circle")
        }

        override func area() -> Double {
            return Double.pi * radius * radius
        }
    }

    class RectangleShape: Shape {
        var width: Double
        var height: Double

        init(width: Double, height: Double) {
            self.width = width
            self.height = height
            super.init(name: "Rectangle")
        }

        override func area() -> Double {
            return width * height
        }
    }

    func displayShapes() {
        let shapes: [Shape] = [
            Circle(radius: 5),
            RectangleShape(width: 4, height: 6)
        ]

        for shape in shapes {
            print("\(shape.name) area: \(shape.area())")
        }
    }

    // --- Exercice 3 ---

    protocol PaymentMethod {
        func total(for amount: Double) -> Double
    }

    struct CreditCard: PaymentMethod {
        func total(for amount: Double) -> Double {
            return amount * 1.02
        }
    }

    struct Cash: PaymentMethod {
        func total(for amount: Double) -> Double {
            return amount
        }
    }

    func processPayment(amount: Double, method: PaymentMethod) {
        let totalAmount = method.total(for: amount)
        print("Total amount to be paid: \(totalAmount)")
    }

    func testExo3() {
        let creditCardPayment = CreditCard()
        let cashPayment = Cash()

        processPayment(amount: 100, method: creditCardPayment)
        processPayment(amount: 100, method: cashPayment)
    }
}