//
//  Extension+String.swift
//  vgsCollect
//
//  Created by Copyright © 2022 Solid. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var isNumeric: Bool {
            guard self.count > 0 else { return false }
            let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            return Set(self).isSubset(of: nums)
    }
    
    var isYearGreate: Bool {
        if Int(self)! >= Calendar.current.component(.year, from: Date()) {
            return true
        } else {
            return false
        }
    }
}
