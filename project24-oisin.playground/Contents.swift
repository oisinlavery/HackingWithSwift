//: Playground - noun: a place where people can play

import UIKit

var myInt = 10

//extension Int {
//    func plusOne() -> Int {
//            return self + 1
//    }
//}

extension Int {

    mutating func plusOne() {
        ++self
    }

    static func random(min min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}

myInt.plusOne()

//let otherInt = 10
//otherInt.plusOne()

Int.random(min: 0, max: 999)