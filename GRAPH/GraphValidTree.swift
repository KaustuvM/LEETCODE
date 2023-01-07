//
//  GraphValidTree.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/2/23.
//

import Foundation

// MARK: LINK - https://leetcode.com/problems/graph-valid-tree/

fileprivate class Solution {
    // define a node
    class Node {
        var id: Int = -1
        var conns = Set<Int>()
        var visited = false
        
        init(_ id: Int) {
            self.id = id
        }
    }
    
    func validTree(_ n: Int, _ edges: [[Int]]) -> Bool {
        // data structure hold the root node
        var root: Int = 0
        // data structure to hold the graph
        var dGraph = Dictionary<Int, Node>()
        // data structure for breadth first traversal
        var queue = Array<Int>()
        var isTree = true
        // queue to hold processed nodes
        var processedNodes = Array<Int>()
        
        // create nodes
        for i in 0..<n {
            dGraph[i] = Node(i)
        }
    
        // build the graph
        for edge in edges {
            if let node0 = dGraph[edge[0]], let node1 = dGraph[edge[1]] {
                node0.conns.insert(node1.id)
                node1.conns.insert(node0.id)
            }
        }
        
        // breadth first traversal
        queue.append(root)
        dGraph[root]!.visited = true
        while !queue.isEmpty && isTree {
            root = queue.removeFirst()
            processedNodes.append(root)
            for conn in dGraph[root]!.conns {
                // remove the reverse path to root so that while processing next level, parent is not referred
                dGraph[conn]!.conns.remove(root)
                if dGraph[conn]!.visited {
                    // this shows that the node is either connected to multiple parents of a peer, hence it cannot be a tree
                    isTree = false
                    break
                } else {
                    dGraph[conn]!.visited = true
                    queue.append(conn)
                }
            }
        }
        // if there are no disconnected graphs and graph is a valid tree, then we should have processed all the nodes by now
        return processedNodes.count == n
    }
}

class GraphValidTree {
    static func execute() {
        print("\n\n--------------------GraphValidTree--------------------")
        let obj = Solution()
        TimeTick.start()
        _ = obj.validTree(5, [[0,1],[0,2],[0,3],[1,4]])
        _ = obj.validTree(5, [[0,1],[1,2],[2,3],[1,3],[1,4]])
        TimeTick.end()
    }
}
