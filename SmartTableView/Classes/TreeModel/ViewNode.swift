//
//  ViewNode.swift
//  SmartTable
//
//  Created by afsana-11711 on 23/04/24.
//

import Foundation

class ViewNode: NSObject{
    var isExpandable: Bool {
            return children != nil
    }
    var shouldExpand: Bool
    var nodeName        : String?
    var nodeID          : String?
    var parentNodeID    : String?
    var parentNodeName  : String?
    var children: [ViewNode]?
    
    init(andChildren children: [ViewNode]? = nil,
         shouldExpand: Bool = false, nodeName : String? = nil, nodeID : String? = nil, unreadCount : Int? = nil, parentNodeID : String? = nil, parentNodeName :String? = nil) {
        self.children = children
        self.shouldExpand = shouldExpand
        self.nodeName = nodeName
        self.nodeID = nodeID
        self.parentNodeID = parentNodeID
        self.parentNodeName = parentNodeName
    }
}

