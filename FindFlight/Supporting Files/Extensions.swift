//
//  Extension.swift
//  FindFlight
//
//  Created by Alex Yatsenko on 19.07.2020.
//  Copyright © 2020 Alexislog's Production. All rights reserved.
//

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
    
    func split() -> [[Element]] {
        let total = self.count
        let half = total / 2
        let leftSplit = self[0..<half]
        let rightSplit = self[half..<total]
        return [Array(leftSplit), Array(rightSplit)]
    }
}
