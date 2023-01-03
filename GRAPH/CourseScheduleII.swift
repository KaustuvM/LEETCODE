//
//  CourseScheduleII.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/2/23.
//

import Foundation

// MARK: LINK - https://leetcode.com/problems/course-schedule-ii/

fileprivate class Solution {
    // define a node
    class Node {
        var id: Int = -1
        var inboundConns = Set<Int>()
        var outboundConns = Set<Int>()
        
        init(_ id: Int) {
            self.id = id
        }
    }
    
    func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
        // data structure to create the dependency graph
        var dGraph = Dictionary<Int, Node>()
        // data structure to hold outbound-only nodes
        var obNodes = Array<Int>()
        // data structure to hold the independent nodes (nodes with no inbound/outbound connection)
        var iNodes = Array<Int>()
        
        // create all the nodes for adjacency list
        for id in 0..<numCourses {
            dGraph[id] = Node(id)
        }
        
        // create the dependency graph
        for req in prerequisites {
            if req[0] >= 0 && req[0] < numCourses
                && req[1] >= 0 && req[1] < numCourses {
                // update outbound connections information for node 'b'
                if let node = dGraph[req[1]] {
                    node.outboundConns.insert(req[0])
                    dGraph[req[1]] = node
                }
                
                // update inbound connections information for node 'a'
                if let node = dGraph[req[0]] {
                    node.inboundConns.insert(req[1])
                    dGraph[req[0]] = node
                }
            }
        }
        
        // populate initial list of outbound-only nodes
        for (_, node) in dGraph {
            if node.inboundConns.isEmpty {
                obNodes.append(node.id)
            }
        }
        
        while !obNodes.isEmpty {
            // get each outbound-only node (obNode) from the queue (obNodes)
            let obNode = obNodes.removeFirst()
            // cache the outbound connections for the outbound-only node
            let obConns = dGraph[obNode]!.outboundConns
            // remove the outbound connections information from the outbound-only node
            dGraph[obNode]!.outboundConns.removeAll()
            // now the obNode is isolated from the graph
            iNodes.append(obNode)
            
            // for each of the outbound connections of obNode, remove its dependency on obNode and check if the cane be considered as isolated node, if 'yes' then add it to obNodes
            for node in obConns {
                dGraph[node]!.inboundConns.remove(obNode)
                if dGraph[node]!.inboundConns.count == 0 {
                    obNodes.append(node)
                }
            }
        }
        // if the graph is a DAG (Directed Acyclic Graph), then all the nodes should be part of iNodes
        return iNodes.count == dGraph.count ? iNodes : []
    }
}

class CourseScheduleII {
    static func execute() {
        print("\n\n--------------------CourseScheduleII--------------------")
        let obj = Solution()
        print(obj.findOrder(2, [[1, 0]]))
        print(obj.findOrder(4, [[1,0],[2,0],[3,1],[3,2]]))
        print(obj.findOrder(1, []))
    }
}
