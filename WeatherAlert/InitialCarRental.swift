import UIKit
import Foundation

// Basic program that calculates a statement of a customer's charges at a car rental store.
//
// A customer can have multiple "Rental"s and a "Rental" has one "Car"
// As an ASCII class diagram:
//          Customer 1 ----> * Rental
//          Rental   * ----> 1 Car
//
// The charges depend on how long the car is rented and the type of the car (economy, muscle or supercar)
//
// The program also calculates frequent renter points.
//
//
// Refactor this class how you would see fit.
//
// The actual code is not that important, as much as its structure. You can even use "magic" functions (e.g. foo.sort()) if you want

enum CarType: Int {
    case economy
    case supercar
    case muscle
}

struct Car {
    let title: String
    let carType: CarType
}

struct Rental {
    let car : Car
    let daysRented: Int
}

class Customer {
    let name: String
    private var rentals = [Rental]()

    init(name: String) {
        self.name = name;
    }

    func addRental(_ arg: Rental) {
        rentals.append(arg)
    }

    func billingStatement() -> String {
        let values = rentals.reduce((amount: 0.0, points: 0, billing: "Rental Record for \(name)\n")) { partialResult, rental in
            var amount = 0.0
            var points = 1
            switch rental.car.carType {
            case .economy:
                amount += 80
                if rental.daysRented > 2 {
                    amount += Double((rental.daysRented - 2) * 30)
                }
            case .supercar:
                amount += Double(rental.daysRented * 200)
                if rental.daysRented > 1 {
                    points += 1
                }
            case .muscle:
                amount += 200
                if rental.daysRented > 3 {
                    amount += Double((rental.daysRented - 3) * 50)
                }
            }
            let billing = "\t\(rental.car.title)\t\(amount)\n"
            return (partialResult.amount + amount, partialResult.points + points, partialResult.billing + billing)
        }
        return "\(values.billing)Final rental payment owed \(values.amount)\nYou received an additional \(values.points) frequent customer points"
    }
}

struct RentTester {
    static func test() {
        let rental1 = Rental(car: Car(title: "Mustang", carType: .muscle), daysRented: 5)
        let rental2 = Rental(car: Car(title: "Lambo", carType: .supercar), daysRented: 20)
        let customer = Customer(name: "Liviu")
        customer.addRental(rental1)
        customer.addRental(rental2)

        print(customer.billingStatement())
    }
}
