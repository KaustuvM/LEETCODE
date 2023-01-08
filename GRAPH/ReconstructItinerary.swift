//
//  ReconstructItinerary.swift
//  LEETCODE
//
//  Created by Kaustuv Mukherjee on 1/7/23.
//

import Foundation

// MARK: LINK - https://leetcode.com/problems/reconstruct-itinerary/

fileprivate class Solution {
    // data structure to hold the graph
    var dGraphOutgoing = Dictionary<String, Array<String>>()
    var dGraphIncoming = Dictionary<String, Array<String>>()
    // keep the tickets for validation of result routes
    var tickets = Array<Array<String>>()
    // keep the cities for validation result routes
    var cities = Set<String>()
    
    func validateRoute(_ route: [String]) -> Array<String> {
        // validate that all tickets are covered
        guard route.count == tickets.count + 1 else {
            return []
        }
        
        // validate that all cities are covered with proper incoming and outgoing connections
        var connCount = Dictionary<String, Array<Int>>()
        var position = 0
        for node in route {
            if connCount[node] == nil {
                connCount[node] = [0, 0]
            }
            if position == 0 {
                connCount[node]![0] += 1
            } else if position > 0 && position < route.count-1 {
                connCount[node]![0] += 1
                connCount[node]![1] += 1
            } else if position == route.count-1 {
                connCount[node]![1] += 1
            }
            position += 1
        }
        
        for city in cities {
            if !route.contains(city) {
                return []
            }
            if connCount[city]![0] != dGraphOutgoing[city]!.count {
                return []
            }
            if connCount[city]![1] != dGraphIncoming[city]!.count {
                return []
            }
        }
        return route
    }
    
    func findSubItenary(_ startNode: String,
                        routeGraph: Dictionary<String, Array<String>>,
                        route: [String]) -> Array<String> {
        // if the validateRoute(...) returns a non empty array, return lclResultRoute
        var lclResultRoute = Array<String>()
        var lclRoute = route
        lclRoute.append(startNode)
        if routeGraph[startNode]!.count == 0 {
            return validateRoute(lclRoute)
        }
        
        for node in routeGraph[startNode]! {
            // create a sub-graph where the connection from startNode to node is removed
            var lclRouteGraph = routeGraph
            let index = lclRouteGraph[startNode]!.firstIndex(of: node)
            lclRouteGraph[startNode]!.remove(at: index!)
            lclResultRoute = findSubItenary(node, routeGraph: lclRouteGraph, route: lclRoute)
            if !lclResultRoute.isEmpty {
                break
            }
        }
        return lclResultRoute
    }
    
    func findItinerary(_ tickets: [[String]]) -> [String] {
        // if the findItinerary(...) returns a non empty array, return lclResultRoute
        var lclResultRoute = Array<String>()
        // initialize class variables
        dGraphOutgoing = Dictionary<String, Array<String>>()
        dGraphIncoming = Dictionary<String, Array<String>>()
        self.tickets = tickets
        cities = Set<String>()
        
        // build the graph
        for ticket in tickets {
            if dGraphOutgoing[ticket[0]] == nil {
                dGraphOutgoing[ticket[0]] = Array<String>()
            }
            if dGraphIncoming[ticket[0]] == nil {
                dGraphIncoming[ticket[0]] = Array<String>()
            }
            if dGraphOutgoing[ticket[1]] == nil {
                dGraphOutgoing[ticket[1]] = Array<String>()
            }
            if dGraphIncoming[ticket[1]] == nil {
                dGraphIncoming[ticket[1]] = Array<String>()
            }
            dGraphOutgoing[ticket[0]]!.append(ticket[1])
            dGraphIncoming[ticket[1]]!.append(ticket[0])
            
            cities.insert(ticket[0])
            cities.insert(ticket[1])
        }
        
        for (node, conns) in dGraphOutgoing {
            dGraphOutgoing[node]! = conns.sorted { $0 < $1 }
        }
        
        for ticket in tickets {
            if ticket[0] == "JFK" {
                lclResultRoute = findSubItenary(ticket[0], routeGraph: dGraphOutgoing, route: [])
                if !lclResultRoute.isEmpty {
                    break
                }
            }
        }
        return lclResultRoute
    }
}

class ReconstructItinerary {
    static func execute() {
        var resultRoutes = Array<Array<String>>()
        let obj = Solution()
        TimeTick.start()
        resultRoutes.append(obj.findItinerary([["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","SFO"]]))
        resultRoutes.append(obj.findItinerary([["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]))
        TimeTick.end()
        for resultRoute in resultRoutes {
            print(resultRoute)
        }
    }
}
