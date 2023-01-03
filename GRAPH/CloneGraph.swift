//
//  CloneGraph.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 12/31/22.
//

import Foundation

// MARK: LINK - https://leetcode.com/problems/clone-graph/

public class Node {
    public var val: Int
    public var neighbors: [Node?]
    public init(_ val: Int) {
        self.val = val
        self.neighbors = []
    }
}

fileprivate class Solution {
    func cloneGraph(_ node: Node?) -> Node? {
        // data structure to create cloned graph
        var cNodes = Dictionary<Int, Node>()
        var cHead: Node?
        // data structure to traverse through the original graph
        var oQueue = Array<Node>()
        var oHead: Node?
        
        oHead = node
        guard let oHead = oHead else {
            return nil
        }
        
        cHead = Node(oHead.val)
        guard let cHead = cHead else {
            return nil
        }
        
        oQueue.append(oHead)
        cNodes[cHead.val] = cHead
        
        // make breadth first traversal of the original graph and create the cloned graph accordingly
        while !oQueue.isEmpty {
            let tmpONode = oQueue.removeFirst()
            guard let tmpCNode = cNodes[tmpONode.val] else {
                return nil
            }
            
            for oNeighbor in tmpONode.neighbors {
                if let oNeighbor = oNeighbor {
                    if let cNeighbor = cNodes[oNeighbor.val] {
                        // for the cloned graph, connect child to parent and hence complete the bidirectional connection between parent and child
                        // for the cloned graph, connect peers
                        tmpCNode.neighbors.append(cNeighbor)
                    } else {
                        // for the cloned graph, connect parent to child
                        let cNeighbor = Node(oNeighbor.val)
                        cNodes[oNeighbor.val] = cNeighbor
                        tmpCNode.neighbors.append(cNeighbor)
                        oQueue.append(oNeighbor)
                    }
                }
            }
        }
        return cHead
    }
}

class CloneGraph {
    static func execute() {
        print("\n\n--------------------CloneGraph--------------------")
        let obj = Solution()
        let node1 = Node(1)
        let node2 = Node(2)
        let node3 = Node(3)
        let node4 = Node(4)
        
        node1.neighbors.append(node2)
        node1.neighbors.append(node4)
        
        node2.neighbors.append(node1)
        node2.neighbors.append(node3)
        
        node3.neighbors.append(node2)
        node3.neighbors.append(node4)
        
        node4.neighbors.append(node3)
        node4.neighbors.append(node1)
        
        if let rootNode = obj.cloneGraph(node1) {
            print(rootNode.val)
        }
        
    }
}
