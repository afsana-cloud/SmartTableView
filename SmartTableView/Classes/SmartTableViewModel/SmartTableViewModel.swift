//
//  SmartTableViewModel.swift
//  SmartTable
//
//  Created by afsana-11711 on 23/04/24.
//

import Foundation

public class SmartTableViewModel {
    //iron
    var nodes: [ViewNode] = []
    
    
    private(set) var hasChildren: Bool = false
    private(set) var isNodeExpanding: Bool = false

    // MARK: - Add/remove nodes
    
    /// Appends children to the selected node of the list.
    /// Returns index paths representing the new nodes.
    func appendChildren(nodes: [ViewNode],parentRow:Int) -> [IndexPath] {
//        if isNodeExpanding && hasChildren{
//            
//        }
        var indexPaths: [IndexPath] = []
        self.nodes.insert(contentsOf: nodes, at: parentRow + 1)
        self.nodes[parentRow].children = nodes
        self.nodes[parentRow].shouldExpand = true
        //self.nodes += nodes
       //
        guard parentRow >= 0 && parentRow < self.nodes.count else { return indexPaths }
         
         // Check if the parent node is expandable
         let parentNode = self.nodes[parentRow]
         guard parentNode.isExpandable, let childrenCount = parentNode.children?.count else { return indexPaths }
         
         let start = parentRow + 1
         let end = start + childrenCount
         for i in start..<end {
             let indexPath = IndexPath(row: i, section: 0)
             indexPaths.append(indexPath)
         }
         
         return indexPaths
    }
    

    
  
    
    /// Finds and removes children of the selected parent from the list.
    /// Returns index paths representing removed nodes.
    func remove(nodes: [ViewNode],parentIndex:Int) -> [IndexPath] {
        var indexesToRemove: IndexSet = IndexSet()
        for token in nodes {
            // Find first occurence of this token.
            for i in 0..<self.nodes.count {
                if self.nodes[i].isEqual(token) {
                    indexesToRemove.insert(i)
                    break
                }
            }
        }
        self.nodes[parentIndex].shouldExpand = false
        return remove(nodesAtIndexes: indexesToRemove)
    }
    
    /// Removes nodes from the list.
    /// Returns index paths representing removed nodes.
    func remove(nodesAtIndexes indexes: IndexSet) -> [IndexPath] {
        var removedIndexPaths: [IndexPath] = []
        var removedCount: Int = 0
        for indexToRemove in indexes.sorted() {
            if !isNodeExpanding {
                removedIndexPaths.append(indexPathForNode(atIndex: indexToRemove))
            }
            let index: Int = indexToRemove - removedCount
            guard index < self.nodes.count else { continue }
            self.nodes.remove(at: index)
            removedCount += 1
        }
        
        
        return removedIndexPaths
    }
    
    /// Removes all nodes from the list.
    /// Returns index paths representing removed nodes.
    func removeAllNodes() -> [IndexPath] {
        let indexPaths: [IndexPath] = isNodeExpanding ? [] : nodes.enumerated().map({ indexPathForNode(atIndex: $0.0) })
        nodes.removeAll()
        return indexPaths
    }
    
    // MARK: - Selecting nodes
    
    var nodesToDisplayCount: Int { return isNodeExpanding ? 0 : nodes.count }
    
    var indexPathsForAllnodes: [IndexPath] {
        var indexPaths: [IndexPath] = []
        for i: Int in 0..<nodes.count {
            indexPaths.append(indexPathForNode(atIndex: i))
        }
        return indexPaths
    }
    
    func node(atIndexPath indexPath: IndexPath) -> ViewNode? {
        let nodeIndex = indexForToken(atIndexPath: indexPath)
        guard nodeIndex >= 0, nodesToDisplayCount > nodeIndex else { return nil }
        return nodes[nodeIndex]
    }
    
     func indexForToken(atIndexPath indexPath: IndexPath) -> Int {
       indexPath.item 
    }
    
     func indexPathForNode(atIndex index: Int) -> IndexPath {
        return IndexPath(item: index,
                         section: 0)
    }
    
    // MARK: - Fetching current node and children
    
    func getCurrentNode(index:Int)->ViewNode{
        let currentNode = nodes[index]
        return currentNode
    }
    
    func getCurrentNodeChildren(index:IndexPath)->[ViewNode]?{
        if let currentNodeChildren = getCurrentNode(index: index.row).children{
            return currentNodeChildren
        }
        return nil
    }
    
    // MARK: - Data source
    
    func numberOfRowsInSection()->[ViewNode]{
        return nodes
    }
    
    func numberOfSections()->Int{
        return 0
    }
    
    
    
}
