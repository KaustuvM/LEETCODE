//
//  LongestIncreasingPathInAMatrix.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/7/23.
//

import Foundation

// MARK: LINK - https://leetcode.com/problems/longest-increasing-path-in-a-matrix/

fileprivate class Solution {
    // all directions that a node can explore
    var directions = [[0, 1]  /*right*/,
                      [1, 0]  /*down*/,
                      [0, -1] /*left*/,
                      [-1, 0] /*up*/]
    
    func longestIncreasingSubpath(_ originX: Int,
                                  _ originY: Int,
                                  _ matrix: inout Array<Array<Int>>,
                                  _ lengthMatrix: inout Array<Array<Int>>) -> Int {
        
        // the node is already explored, no need to proceed further, simply return the existing value
        guard lengthMatrix[originX][originY] == 0 else {
            return lengthMatrix[originX][originY]
        }
        
        // the logic is to explore a node in all possible directions (right/down/left/up) within the constraints
        for direction in directions {
            let nextOriginX = originX + direction[0]
            let nextOriginY = originY + direction[1]
            if nextOriginX >= 0
                && nextOriginX < matrix.count
                && nextOriginY >= 0
                && nextOriginY < lengthMatrix[nextOriginX].count
                && matrix[nextOriginX][nextOriginY] > matrix[originX][originY] {
                // each path is explored in reverse direction, the last one first, this is done to cache
                lengthMatrix[originX][originY] = max(lengthMatrix[originX][originY],
                                                     longestIncreasingSubpath(nextOriginX,
                                                                              nextOriginY,
                                                                              &matrix,
                                                                              &lengthMatrix) + 1)
            }
        }
        // when the execution reaches here, it means that matrix[originX][originY] is completey explored
        return lengthMatrix[originX][originY]
    }
    
    func longestIncreasingPath(_ matrix: [[Int]]) -> Int {
        // data structure to hold maxValue
        var maxValue = 0
        var lclMatrix = matrix
        var lengthMatrix = Array<Array<Int>>(repeating: Array(repeating: 0, count: matrix[0].count), count: matrix.count)
        
        for row in 0..<matrix.count {
            for col in 0..<matrix[row].count {
                maxValue = max(maxValue, longestIncreasingSubpath(row, col, &lclMatrix, &lengthMatrix))
            }
        }
        return maxValue+1
    }
}

class LongestIncreasingPathInAMatrix {
    static func execute() {
        let obj = Solution()
        TimeTick.start()
        _ = obj.longestIncreasingPath([[0, 1], [3, 2]])
        _ = obj.longestIncreasingPath([[9,9,4],[6,6,8],[2,1,1]])
        _ = obj.longestIncreasingPath([[3,4,5],[3,2,6],[2,2,1]])
        TimeTick.end()
    }
}
