//
//  SmartTableView.swift
//  SmartTable
//
//  Created by afsana-11711 on 23/04/24.
//

import Foundation
import UIKit


class SmartTableView: UITableView, UITableViewDataSource, UITableViewDelegate{
 
    
    private let viewModel: SmartTableViewModel = SmartTableViewModel()
    
//    // MARK: - Initialization
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//        setUpTableView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setUpTableView()
//    }
//    
//    public init(datasource:[ViewNode],frame:CGRect,style:UITableView.Style){
//        super.init(frame: frame,style: style)
//        viewModel.nodes = datasource
//        setUpTableView()
//    }
    

    
    
    /// - Parameters:
    ///   - tokens: Tokens to append.
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    //iron
    
    func setUpTableView(datasource:[ViewNode]){
        self.dataSource = self
        self.delegate = self
        viewModel.nodes = datasource
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    public func append(nodes: [ViewNode], animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
       
//        let newIndexPaths = viewModel.append(nodes: nodes)
//        insertItems(atIndexPaths: newIndexPaths, animated: animated, completion: completion)
        
    }
    
    
    /// Remove provided tokens, if they are in the token field.
    ///
    /// - Parameters:
    ///   - tokens: Tokens to remove.
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func remove(nodes: [ViewNode], animated: Bool = false) {
//        let removedIndexPaths = viewModel.remove(nodes: nodes)
//        removeItems(atIndexPaths: removedIndexPaths, animated: animated, completion: completion)
      
    }
    
    /// Remove tokens at provided indexes, if they are in the token field.
    /// Faster than `remove(tokens:)`.
    ///
    /// - Parameters:
    ///   - indexes: Indexes of tokens to remove.
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
    public func remove(tokensAtIndexes indexes: IndexSet, animated: Bool = false) {
        let removedIndexPaths = viewModel.remove(nodesAtIndexes: indexes)
        removeItems(atIndexPaths: removedIndexPaths, animated: animated)
    }
    
    /// Removes all tokens.
    ///
    /// - Parameters:
    ///   - animated: If `true` changes will be animated.
    ///   - completion: Completion handler.
//    public func removeAllTokens(animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
//        let removedIndexPaths = viewModel.removeAllTokens()
//        removeItems(atIndexPaths: removedIndexPaths, animated: animated, completion: completion)
//    }
    
    private func insertItems(atIndexPaths indexPaths: [IndexPath], animated: Bool) {
        if animated {
            self.insertRows(at: indexPaths, with: .automatic)
            
        } else {
            self.insertRows(at: indexPaths, with: .none)
        }
    }
    
    private func removeItems(atIndexPaths indexPaths: [IndexPath], animated: Bool) {
        if animated {
            self.deleteRows(at: indexPaths, with: .automatic)
            
        } else {
            self.deleteRows(at: indexPaths, with: .none)
        }
    }
    
    
    func updateChildrenRowsFromTable(indexPath:IndexPath){
        if viewModel.nodes[indexPath.row].shouldExpand{
            if let children = viewModel.nodes[indexPath.row].children{
                let removedIndex = viewModel.remove(nodes: children,parentIndex: indexPath.row)
                DispatchQueue.main.async {
                    self.beginUpdates()
                    self.deleteRows(at: removedIndex, with: .automatic)
                    self.endUpdates()
                }
            }
        }else{
            if let children = viewModel.getCurrentNodeChildren(index: indexPath){
                let newIndexPaths = viewModel.appendChildren(nodes: children, parentRow: indexPath.row)
                DispatchQueue.main.async {
                    self.beginUpdates()
                    self.insertRows(at: newIndexPaths, with: .automatic)
                    self.endUpdates()
                }
            }
        }
       
    }
    
    func insertChildrenInTable(indexPath:IndexPath){
        if let children = viewModel.getCurrentNodeChildren(index: indexPath){
            let newIndexPaths = viewModel.appendChildren(nodes: children, parentRow: indexPath.row)
            DispatchQueue.main.async {
                self.beginUpdates()
                self.insertRows(at: newIndexPaths, with: .automatic)
                self.endUpdates()
            }
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let node = viewModel.nodes[indexPath.row]
        cell.textLabel?.text = node.nodeName
        let dropdownButton = UIButton(type: .system)
        // Add dropdown button to each cell
        if let children = node.children{
            dropdownButton.setTitle("▼", for: .normal)
            dropdownButton.sizeToFit()
            dropdownButton.addTarget(self, action: #selector(dropdownButtonTapped(_:)), for: .touchUpInside)
            cell.accessoryView = dropdownButton
        }else{
            cell.accessoryView = nil
        }
        
        
        return cell
    }
    
    // MARK: - Dropdown button action
    
    @objc func dropdownButtonTapped(_ sender: UIButton) {
        // Find the corresponding cell
        if let cell = sender.superview as? UITableViewCell,
           let indexPath = self.indexPath(for: cell) {
            if viewModel.nodes[indexPath.row].shouldExpand{
                let removedIndex = viewModel.remove(nodes: viewModel.nodes[indexPath.row].children!,parentIndex: indexPath.row)
                DispatchQueue.main.async {
                    self.beginUpdates()
                    self.deleteRows(at: removedIndex, with: .automatic)
                    self.endUpdates()
                }
            }else{
                if let children = viewModel.getCurrentNodeChildren(index: indexPath){
                    let newIndexPaths = viewModel.appendChildren(nodes: children, parentRow: indexPath.row)
                    DispatchQueue.main.async {
                        self.beginUpdates()
                        self.insertRows(at: newIndexPaths, with: .automatic)
                        self.endUpdates()
                    }
                }
            }
        }
    }
    
}
