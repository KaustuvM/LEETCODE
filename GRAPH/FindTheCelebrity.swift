//
//  FindTheCelebrity.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/2/23.
//

import Foundation

fileprivate class Solution {
    var graph = Array<Array<Int>>()
    
    // this function is already defined in the base class of the original problem in LEETCODE
    func knows(_ a: Int, _ b: Int) -> Bool {
        return graph[a][b] == 1 ? true : false
    }
    
    func findCelebrity(_ n: Int) -> Int {
        // by default lets take 0 as the celebrity
        var celebrity = 0
        var count = 1
        // the below logic ensures that if 'x' is the celebrity then 'x' does not know anybody from 'x+1' to 'n-1'
        while count < n {
            if knows(celebrity, count) {
                celebrity = count
            }
            count += 1
        }
        // however this does not mean that (1) all from '0' to 'n-1' (excluding 'x') know the celebrity and (2) the celebrity does not know anybody from '0' to 'x-1'
        // to ensure that below is the logic
        for i in 0..<n {
            if i != celebrity && (knows(celebrity, i) || !knows(i, celebrity)) {
                celebrity = -1
                break
            }
        }
        return celebrity
    }
}

class FindTheCelebrity {
    static func execute() {
        print("\n\n--------------------FindTheCelebrity--------------------")
        let obj = Solution()
        obj.graph = [[1,1],[0,1]]
        print(obj.findCelebrity(obj.graph.count))
        obj.graph = [[1,0,0],[1,1,0],[1,0,1]]
        print(obj.findCelebrity(obj.graph.count))
        obj.graph = [[1,0],[0,1]]
        print(obj.findCelebrity(obj.graph.count))
        obj.graph = [[1,1,0],[0,1,0],[1,1,1]]
        print(obj.findCelebrity(obj.graph.count))
        obj.graph = [[1,0,1],[1,1,0],[0,1,1]]
        print(obj.findCelebrity(obj.graph.count))
    }
}
