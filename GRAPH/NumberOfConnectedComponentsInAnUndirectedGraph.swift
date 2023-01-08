//
//  NumberOfConnectedComponentsInAnUndirectedGraph.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/7/23.
//

import Foundation

// MARK: LINK - https://leetcode.com/problems/number-of-connected-components-in-an-undirected-graph/

fileprivate class Solution {
    // define a node
    class Node {
        var id = -1
        var edges = Set<Int>()
        var visited = false
        
        init(_ id: Int) {
            self.id = id
        }
    }
    
    func countComponents(_ n: Int, _ edges: [[Int]]) -> Int {
        // data structure to hold all the nodes ids
        var nodeIds = Set<Int>()
        // data structure to hold the graph
        var dGraph = Dictionary<Int, Node>()
        // data structure to perform breadth first traversal
        var queue = Array<Int>()
        var head = -1
        // keep the number of graph count
        var count = 0

        // create the graph
        for i in 0..<n {
            nodeIds.insert(i)
            dGraph[i] = Node(i)
        }
        for edge in edges {
            dGraph[edge[0]]!.edges.insert(edge[1])
            dGraph[edge[1]]!.edges.insert(edge[0])
        }
        
        // for each node in nodeIds, traverse through the dependencies (breadth first traversal) and remove the visited nodes from nodeIds.
        // implement graph count on completion of each breadth first traversal
        while !nodeIds.isEmpty {
            head = nodeIds.removeFirst()
            dGraph[head]!.visited = true
            queue.append(head)
            count += 1
            
            while !queue.isEmpty {
                head = queue.removeFirst()
                nodeIds.remove(head)
                
                for node in dGraph[head]!.edges {
                    if dGraph[node]!.visited == false {
                        queue.append(node)
                        dGraph[node]!.visited = true
                    }
                }
            }
        }
        return count
    }
}

class NumberOfConnectedComponentsInAnUndirectedGraph {
    static func execute() {
        let obj = Solution()
        
        TimeTick.start()
        _ = obj.countComponents(5, [[0,1],[1,2],[3,4]])
        _ = obj.countComponents(5, [[0,1],[1,2],[2,3],[3,4]])
        TimeTick.end()
    }
}
