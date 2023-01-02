//
//  PerformanceAnalysis.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/1/23.
//

import Foundation

class TimeTick {
    static var timeConsumed: Double = 0
    static var startTime = DispatchTime.now().uptimeNanoseconds
    static var endTime = DispatchTime.now().uptimeNanoseconds
    
    static func start() {
        startTime = DispatchTime.now().uptimeNanoseconds
    }
    
    static func end() {
        endTime = DispatchTime.now().uptimeNanoseconds
        print("Execution time: \(Double(endTime-startTime)/1000000) msec")
    }
}
