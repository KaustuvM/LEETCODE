//
//  AlienDictionary.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/2/23.
//

import Foundation

// MARK: LINK - https://leetcode.com/problems/alien-dictionary/

fileprivate class Solution {
    // define a node
    class Node {
        var char: Character = "?"
        var inboundConns = Set<Character>()
        var outboundConns = Set<Character>()
        
        init(_ char: Character) {
            self.char = char
        }
    }
    
    // data structure to hold the graph
    var dGraph = Dictionary<Character, Node>()
    
    // function to validate the sequence of words and create graph
    func validateAndUpdateGraph(_ prevWord: Array<Character>?, _ currWord: Array<Character>) -> Bool {
        guard let prevWord = prevWord else {
            for i in 0..<currWord.count {
                if dGraph[currWord[i]] == nil {
                    dGraph[currWord[i]] = Node(currWord[i])
                }
            }
            return true
        }
        // prefix validation
        if prevWord.count > currWord.count {
            // since the previous is longer than current word, if they start with a prefix and currWord contains only prefix then the sequence of words is invalid (e.g. "bbcd", "bb"
            var count = 0
            for i in 0..<currWord.count {
                if prevWord[i] == currWord[i] {
                    count += 1
                }
            }
            if count == currWord.count {
                return false
            }
        }
        
        // create the graph
        if prevWord.count >= currWord.count {
            var diffFound = false
            for i in 0..<currWord.count {
                if dGraph[prevWord[i]] == nil {
                    dGraph[prevWord[i]] = Node(prevWord[i])
                }
                if dGraph[currWord[i]] == nil {
                    dGraph[currWord[i]] = Node(currWord[i])
                }
                if prevWord[i] != currWord[i] && !diffFound {
                    dGraph[prevWord[i]]!.outboundConns.insert(currWord[i])
                    dGraph[currWord[i]]!.inboundConns.insert(prevWord[i])
                    // mapping should be stopped from now onwards as the non-identical characters have been identified
                    diffFound = true
                }
            }
            for i in currWord.count..<prevWord.count {
                if dGraph[prevWord[i]] == nil {
                    dGraph[prevWord[i]] = Node(prevWord[i])
                }
            }
        } else {
            var diffFound = false
            for i in 0..<prevWord.count {
                if dGraph[prevWord[i]] == nil {
                    dGraph[prevWord[i]] = Node(prevWord[i])
                }
                if dGraph[currWord[i]] == nil {
                    dGraph[currWord[i]] = Node(currWord[i])
                }
                if prevWord[i] != currWord[i] && !diffFound {
                    dGraph[prevWord[i]]!.outboundConns.insert(currWord[i])
                    dGraph[currWord[i]]!.inboundConns.insert(prevWord[i])
                    // mapping should be stopped from now onwards as the non-identical characters have been identified
                    diffFound = true
                }
            }
            for i in prevWord.count..<currWord.count {
                if dGraph[currWord[i]] == nil {
                    dGraph[currWord[i]] = Node(currWord[i])
                }
            }
        }
        
        return true
    }
    
    func alienOrder(_ words: [String]) -> String {
        // data structure required for processing DAG (Directed Acyclic Graph)
        var obNodes = Array<Character>()
        var iNodes = Array<Character>()
        // initialize the graph
        dGraph = Dictionary<Character, Node>()
        // validate and update the graph
        if words.count == 1 {
            if !validateAndUpdateGraph(nil, Array<Character>(words[0])) {
                return ""
            }
        } else {
            for i in 0..<words.count-1 {
                if !validateAndUpdateGraph(Array<Character>(words[i]), Array<Character>(words[i+1])) {
                    return ""
                }
            }
        }
        
        // now prove that dGraph is a DAG (Directed Acyclic Graph)
        for (char, node) in dGraph {
            if node.inboundConns.count == 0 {
                obNodes.append(char)
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
        
        return iNodes.count == dGraph.count ? String(iNodes) : ""
    }
}

class AlienDictionary {
    static func execute() {
        print("\n\n--------------------AlienDictionary--------------------")
        let obj = Solution()
        TimeTick.start()
        _ = obj.alienOrder(["wnlb"])
        _ = obj.alienOrder(["ac","ab","zc","zb"])
        _ = obj.alienOrder(["wrt","wrf","er","ett","rftt"])
        _ = obj.alienOrder(["z","x"])
        _ = obj.alienOrder(["z","x","z"])
        TimeTick.end()
    }
}
