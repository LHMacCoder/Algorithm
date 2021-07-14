//
//  UnionFind.swift
//  Algorithm
//
//  Created by LHMacCoder on 2020/8/18.
//  Copyright © 2020 LHMacCoder. All rights reserved.
//

import Foundation

/// 使用路径压缩、分裂或减半 + 基于rank或者size的优化，可以确保每个操作的均摊时间复杂度为：
/// O(a(n)),其中a(n) < 5
/// 建议搭配方案：Quick Union + 基于rank的优化 + 路径减半或者路径分裂
class UnionFind: CustomStringConvertible {
    var parents: [Int]
    var size: [Int]
    var rank: [Int]
    init?(capacity: Int) {
        guard capacity > 0 else {
            return nil
        }
        parents = Array.init(repeating: 0, count: capacity)
        size = Array.init(repeating: 1, count: capacity)
        rank = Array.init(repeating: 1, count: capacity)

        for i in 0..<capacity {
            parents[i] = i
        }
    }
    
    var description: String {
        return "\(self.parents)"
    }
}


/// Quick Find:
///
/// 查找的时间复杂度：O(1)
/// 合并的时间复杂度：O(n)
/// 树的高度：<= 2
extension UnionFind {
    /// 通过Quick Find查找元素所在的集合（根结点）
    ///
    /// - Parameter value: 查找的元素
    /// - Returns: 元素所在的集合
    func findQF(value: Int) -> Int? {
        guard value < parents.count else {
            return nil
        }
        return parents[value]
    }
    
    /// 通过Quick Find合并两个元素所在的集合
    ///
    /// - Parameters:
    ///   - value1: 元素1
    ///   - value2: 元素2
    func unionQF(value1: Int, value2: Int) {
        guard (value1 < parents.count && value1 >= 0) &&
            (value2 < parents.count && value2 >= 0) else {
                return
        }
        let p1 = findQF(value: value1)
        let p2 = findQF(value: value2)
        
        guard p1 != p2 else {
            return
        }
        
        for i in 0..<parents.count {
            if (parents[i] == p1) {
                parents[i] = p2!
            }
        }
    }
    
    /// 判断两个元素是否在同一个集合
    ///
    /// - Parameters:
    ///   - value1: 元素1
    ///   - value2: 元素2
    /// - Returns: 结果
    func isSameQF(value1: Int, value2: Int) -> Bool {
        return findQF(value: value1) == findQF(value: value2)
    }
}

/// Quick Union:
///
/// 查找的时间复杂度：O(log(n))，可以优化至O(a(n)，a(n) < 5
/// 合并的时间复杂度：O(log(n))，可以优化至O(a(n)，a(n) < 5
/// 树的高度：>= 1
extension UnionFind {
  
    /// 通过Quick Union查找元素所在的集合（根结点）
    ///
    /// - Parameter value: 查找的元素
    /// - Returns: 元素所在的集合
    func findQU(value: Int) -> Int? {
        guard value < parents.count else {
            return nil
        }
        var v = value
        while parents[v] != v {
            v = parents[v]
        }
        return parents[v]
    }
    
    /// 通过Quick Union合并两个元素所在的集合
    ///
    /// - Parameters:
    ///   - value1: 元素1
    ///   - value2: 元素2
    func unionQU(value1: Int, value2: Int) {
        guard (value1 < parents.count && value1 >= 0) &&
            (value2 < parents.count && value2 >= 0) else {
                return
        }
        let p1 = findQU(value: value1)!
        let p2 = findQU(value: value2)!
        parents[p1] = p2
    }
}

/// Quick Union优化：
/// Quick Union有可能会造成树不平衡的状态，甚至退化成链表的结构。
/// 2种优化方案：
/// 1.基于size的优化：元素少的树，接到元素多的树上
/// 2.基于rank的优化：矮的树接到高的树上
extension UnionFind {
    /// Quick Union 基于size的优化
    ///
    /// - Parameters:
    ///   - value1: 元素1
    ///   - value2: 元素2
    func unionQU_S(value1: Int, value2: Int) {
        guard (value1 < parents.count && value1 >= 0) &&
            (value2 < parents.count && value2 >= 0) else {
                return
        }
        let p1 = findQU(value: value1)!
        let p2 = findQU(value: value2)!
        
        let s1 = size[p1]
        let s2 = size[p2]
        
        if (s1 > s2) {
            parents[p2] = p1
            size[p1] += s2
        }
        else {
            parents[p1] = p2
            size[p2] += s1
        }
    }
    
    /// 基于size的优化也可能存在树不平衡的情况出现，只不过相对于func unionQU()而言，
    /// 概率低很多而已，基于rank的优化，树就会相对平衡一些。
    /// Quick Union 基于rank的优化
    ///
    /// - Parameters:
    ///   - value1: 元素1
    ///   - value2: 元素2
    func unionQU_R(value1: Int, value2: Int) {
        guard (value1 < parents.count && value1 >= 0) &&
            (value2 < parents.count && value2 >= 0) else {
                return
        }
        let p1 = findQU(value: value1)!
        let p2 = findQU(value: value2)!
        
        let r1 = rank[p1]
        let r2 = rank[p2]
        
        if (r1 > r2) {
            parents[p2] = p1
        }
        else if (r1 < r2){
            parents[p1] = p2
        }
        else {
            parents[p1] = p2
            rank[p2] += 1
        }
    }
}

/// Quick Union基于rank的优化，虽然能让树相对平衡，但是
/// 随着不断的合并，树的高度也将不断的增高，导致find的效率
/// 越来越低，尤其是尾节点。
/// 3种优化方案：
/// 1.路径压缩（Path Compression）：在find的时候，使路径上的所有子节点指向根节点，
/// 降低树的高度，但是实现成本稍高。
/// 2.路径分裂（Path Spiting）：使路径上的每个节点，都指向其祖父节点，不仅降低树的高度，
/// 而且实现成本比路径压缩要低。
/// 3.路径减半（Path Halving）：使路径上每隔一个节点，指向其祖父节点，效率和路径分裂差不多。
extension UnionFind {
    /// 通过Quick Union Path Compression查找元素所在的集合（根结点）
    ///
    /// - Parameter value: 查找的元素
    /// - Returns: 元素所在的集合
    func findQU_PC(value: Int) -> Int? {
        guard value < parents.count else {
            return nil
        }
        let v = value
        while parents[v] != v {
            parents[v] = findQU_PC(value: parents[v])!
        }
        return parents[v]
    }
    
    /// 通过Quick Union Path Spliting查找元素所在的集合（根结点）
    ///
    /// - Parameter value: 查找的元素
    /// - Returns: 元素所在的集合
    func findQU_PS(value: Int) -> Int? {
        guard value < parents.count else {
            return nil
        }
        var v = value
        while parents[v] != v {
            let parent = parents[v]
            parents[v] = parents[parent]
            v = parent
            
        }
        return parents[v]
    }
    
    /// 通过Quick Union Path Halving查找元素所在的集合（根结点）
    ///
    /// - Parameter value: 查找的元素
    /// - Returns: 元素所在的集合
    func findQU_PH(value: Int) -> Int? {
        guard value < parents.count else {
            return nil
        }
        var v = value
        while parents[v] != v {
            let parent = parents[v]
            parents[v] = parents[parent]
            v = parents[v]
            
        }
        return parents[v]
    }
}



/// 范型UnionFind，基于：Quick Union + 基于rank的优化 + 路径减半
class GenericUnionFind<T: Hashable>: CustomStringConvertible {
    private var nodes: Dictionary<T, Node<T>>
    
    private class Node<T> {
        var value: T
        var rank = 1
        weak var parent: Node<T>?
        init(value: T) {
            self.value = value
            self.parent = nil
        }
    }
    
    init() {
        nodes = Dictionary<T, Node<T>>()
    }
    
    func makeNode(nodeValue: T) {
        if nodes[nodeValue] == nil {
            let node = Node.init(value: nodeValue)
            node.parent = node
            nodes[nodeValue] = node
        }
    }
    
    /// 查找节点的根节点
    private func findNode(nodeValue: T) -> Node<T>? {
        guard var node = nodes[nodeValue] else {
            return nil
        }
        while node.value != node.parent?.value {
            node.parent = node.parent?.parent
            node = node.parent!
        }
        return node
    }
    
    /// 查找所在集合
    func find(nodeValue: T) -> T? {
        guard let node = findNode(nodeValue: nodeValue) else {
            return nil
        }
        return node.value
    }

    /// 判断是否在同一个集合
    func isSame(lnv: T, rnv: T) -> Bool {
        return find(nodeValue: lnv) == find(nodeValue: rnv)
    }
    
    /// 合并两个集合
    func union(lnv: T, rnv: T) {
        guard let leftNode = findNode(nodeValue: lnv),let rightNode = findNode(nodeValue: rnv) else {
            return
        }
        if leftNode.value == rightNode.value {
            return
        }
        if leftNode.rank < rightNode.rank {
            leftNode.parent = rightNode
        }
        else if leftNode.rank > rightNode.rank {
            rightNode.parent = leftNode
        }
        else {
            leftNode.parent = rightNode
            rightNode.rank += 1
        }
    }
    
    var description: String {
        var string: String = String()
        for (key, _) in self.nodes {
            string += """
            node: \(key), parentNode: \(String(describing: findNode(nodeValue: key)?.value)), \
            rank: \(String(describing: findNode(nodeValue: key)?.rank))\n
            """
        }
        return string
    }
}
