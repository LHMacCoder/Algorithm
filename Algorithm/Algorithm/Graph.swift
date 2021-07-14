//
//  Graph.swift
//  Algorithm
//
//  Created by LHMacCoder on 2020/8/29.
//  Copyright © 2020 LHMacCoder. All rights reserved.
//

import Foundation

class Graph<V: Hashable & CustomStringConvertible, T: Comparable> {
    
    /// 所有的顶点
    private var vertices: Dictionary<V, Vertex>
    
    /// 所有的边
    private var edges: Set<Edge>

    init() {
        vertices = Dictionary<V, Vertex>()
        edges = Set<Edge>()
    }
    
    /// 顶点总数
    var verticesSize: Int {
        return vertices.count
    }
    
    /// 边总数
    var edgesSize: Int {
        return edges.count
    }
    
    /// 顶点对象
    private class Vertex: Hashable, CustomStringConvertible {
        /// 顶点的值
        var value: V
        /// 顶点的所有入边
        var inEdges: Set<Edge>
        /// 顶点的所有出边
        var outEdges: Set<Edge>

        init(vertex value: V) {
            self.value = value
            inEdges = Set<Edge>()
            outEdges = Set<Edge>()
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
        
        static func == (lhs: Vertex, rhs: Vertex) -> Bool {
            return lhs.value == rhs.value
        }
        
        var description: String {
            return "\(value)"
        }
    }
    
    /// 边的信息对象
    class EdgeInfo: CustomStringConvertible {
        /// 权重
        let weight: T
        /// 源顶点
        let from: V
        /// 目的顶点
        let to: V
        init(from: V, to: V, weight: T) {
            self.from = from
            self.to = to
            self.weight = weight
        }
        var description: String {
            return "Edge [from = \(from), to = \(to), weight = \(weight)]"
        }
    }
    
    /// 路径信息对象
    class PathInfo: CustomStringConvertible {
        /// 总权重
        var weight: T
        /// 路径所包含的边
        var edgesInfo: [EdgeInfo]
        init(weight: T, edges: [EdgeInfo]) {
            self.weight = weight
            self.edgesInfo = edges
        }
        var description: String {
            return "\(weight),\(edgesInfo)"
        }
        
    }
    
    /// 边对象
    private class Edge: Hashable, Comparable, CustomStringConvertible {
        /// 边的权
        var weight: T!
        /// 源顶点
        var fromVertex: Vertex
        /// 目的顶点
        var toVertex: Vertex
        /// 边信息
        var edgeInfo: EdgeInfo {
            return EdgeInfo.init(from: fromVertex.value, to: toVertex.value, weight: weight)
        }

        init(edge weight: T?, fromVertex from: Vertex, toVertex to: Vertex) {
            self.weight = weight
            self.fromVertex = from
            self.toVertex = to
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(fromVertex)
            hasher.combine(toVertex)
        }
        
        static func == (lhs: Edge, rhs: Edge) -> Bool {
            return lhs.fromVertex == rhs.fromVertex && lhs.toVertex == rhs.toVertex && lhs.weight == rhs.weight
        }
        
        static func < (lhs: Edge, rhs: Edge) -> Bool {
            return  lhs.weight < rhs.weight

        }
        
        static func > (lhs: Edge, rhs: Edge) -> Bool {
            return  lhs.weight > rhs.weight
            
        }
        
        var description: String {
            return "Edge [from = \(fromVertex), to = \(toVertex), weight = \(String(describing: weight))]"
        }
    }
    
    /// 添加无边顶点
    func addVertex(vertex: V) {
        guard vertices[vertex] == nil else {
            return
        }
        let vertexObj = Vertex.init(vertex: vertex)
        vertices[vertex] = vertexObj
    }
    
    /// 添加无权边
    func addEdge(from: V, to: V) {
        addEdge(from: from, to: to, weight: nil)
    }
    
    /// 添加一条有权边
    func addEdge(from: V, to: V, weight: T?) {
        /// 先判断from是否已经存在
        if vertices[from] == nil {
            vertices[from] = Vertex.init(vertex: from)
        }
        
        if vertices[to] == nil {
            vertices[to] = Vertex.init(vertex: to)
        }
        
        let fromObj = vertices[from]!
        let toObj = vertices[to]!
        /// 创建边
        let edge = Edge.init(edge: weight, fromVertex: fromObj, toVertex: toObj)
        /// 如果边已经存在，先删除
        if fromObj.outEdges.remove(edge) != nil {
            toObj.inEdges.remove(edge)
            edges.remove(edge)
        }
        fromObj.outEdges.insert(edge)
        toObj.inEdges.insert(edge)
        edges.insert(edge)
    }
    
    /// 删除顶点
    func removeVertex(vertex: V) {
        if let vertexObj = vertices.removeValue(forKey: vertex) {
            var array = Array<Edge>()
            for edge in edges {
                if edge.fromVertex == vertexObj || edge.toVertex == vertexObj {
                    array.append(edge)
                }
            }
            for edge in array {
                edges.remove(edge)
                for (_, otherVertex) in vertices {
                    otherVertex.inEdges.remove(edge)
                    otherVertex.outEdges.remove(edge)
                }
            }
        }
    }
    
    /// 删除边
    func removeEdge(from: V, to: V) {
        if let fromVertex = vertices[from], let toVertex = vertices[to] {
            let newEdge = Edge.init(edge: nil, fromVertex: fromVertex, toVertex: toVertex)
            if fromVertex.outEdges.remove(newEdge) != nil {
                toVertex.inEdges.remove(newEdge)
                edges.remove(newEdge)
            }
        }
    }
    
    
    /// 广度优先搜索
    ///
    /// - Parameters:
    ///   - vertex: 开始的顶点
    ///   - closure: 搜索的顶点闭包
    func bfs(vertex: V, closure: (_ vertex: V) -> Bool) {
        if let firstVertex = vertices[vertex] {
            // 用数组队列保存即将搜索的顶点
            var arrayList: Array<Vertex> = Array.init()
            // 过滤已经搜索的顶点
            var filterSet: Set<Vertex> = Set.init()
            arrayList.append(firstVertex)
            filterSet.insert(firstVertex)
            while (arrayList.first != nil) {
                // 从数组队列第一个顶点开始
                let searchVertex = arrayList.removeFirst()
                // 将该顶点的所有出边到达的顶点加入搜索队列
                for edge in searchVertex.outEdges {
                    if filterSet.contains(edge.toVertex) {
                        continue
                    }
                    arrayList.append(edge.toVertex)
                    filterSet.insert(edge.toVertex)
                }
                filterSet.insert(searchVertex)
                if closure(searchVertex.value) {
                    return
                }
            }
        }
    }
    
    /// 深度优先搜索
    /*
    /// 递归实现算法
    func dfs(vertex: V, closure: (_ vertex: V) -> Bool) {
        if let vertexObject = vertices[vertex] {
            var filterSet: Set<Vertex> = Set.init()
            dfs(vertexObject: vertexObject, filterSet: &filterSet) {closure($0)}
        }
    }
    
    private func dfs(vertexObject: Vertex, filterSet: inout Set<Vertex>, closure: (_ vertex: V) -> Bool) {
        if !filterSet.contains(vertexObject) {
            if closure(vertexObject.value) {
                return
            }
            filterSet.insert(vertexObject)
        }

        for edge in vertexObject.outEdges {
            if filterSet.contains(edge.toVertex) {
                continue
            }
            if closure(edge.toVertex.value) {
                return
            }
            filterSet.insert(edge.toVertex)
            dfs(vertexObject: edge.toVertex, filterSet: &filterSet) {closure($0)}
        }
    }
*/
    
    /// 深度优先搜索非递归实现
    ///
    /// - Parameters:
    ///   - vertex: 开始的顶点
    ///   - closure: 搜索的顶点闭包
    func dfs(vertex: V, closure: (_ vertex: V) -> Bool) {
        guard let searchVertex = vertices[vertex] else {
            return
        }
        // 数组栈
        var arrayStack: Array<Vertex> = Array.init()
        // 过滤已经搜索过的顶点
        var filterSet: Set<Vertex> = Set.init()
        arrayStack.append(searchVertex)
        if closure(searchVertex.value) {
            return
        }
        filterSet.insert(searchVertex)
        while !arrayStack.isEmpty {
            let topVertex = arrayStack.removeLast()
            for edge in topVertex.outEdges {
                if filterSet.contains(edge.toVertex) {
                    continue
                }
                arrayStack.append(edge.fromVertex)
                arrayStack.append(edge.toVertex)
                filterSet.insert(edge.toVertex)
                if closure(edge.toVertex.value) {
                    return
                }
                break
            }
        }
    }
    
    /// 拓扑排序
    ///
    /// - Returns: 拓扑排序后的顶点
    func topologicalSort() -> Array<V> {
        var sortResult = Array<V>()
        // 入度字典，保存每个顶点的入度
        var inSizeDic = Dictionary<Vertex, Int>()
        // 入度为0的顶点队列
        var queue = Array<Vertex>()
        
        // 先找出所有入度为0的顶点，加入队列中
        for (_, vertex) in vertices {
            if vertex.inEdges.count == 0 {
                queue.append(vertex)
            }
            else {
                inSizeDic[vertex] = vertex.inEdges.count
            }
        }
        
        // 从队列取出元素，加入排序数组，对元素的outEdges.toVertex的入度减1
        // 如果入度为0，将顶点加入队列
        while !queue.isEmpty {
            let vertex = queue.removeFirst()
            sortResult.append(vertex.value)
            for edge in vertex.outEdges {
                if let inSize = inSizeDic[edge.toVertex] {
                    if inSize - 1 == 0 {
                        queue.append(edge.toVertex)
                    }
                    else {
                        inSizeDic[edge.toVertex] = inSize - 1
                    }
                }
            }
        }
        return sortResult
    }
    
    /// 最小生成树Prim算法实现
    ///
    /// - Returns: 最小生成树的所有路径信息
    func prim() -> Array<EdgeInfo>? {
        // 如果图没有顶点，返回nil
        let verticesSize = vertices.count
        if verticesSize == 0 {
            return nil
        }
        var edgesInfo = Array<EdgeInfo>()
        // 获取首个顶点
        let vertex = vertices.first!.value
        
        // 以该顶点的所有出边创建最小堆
        let heap = BinaryHeap<Edge>.init()
        heap.isMax = false
        heap.heapify(elements: Array(vertex.outEdges))
        heap.heapPrint()
        // 已经被添加过的顶点，以防构成环
        var addedVertices = Set<Vertex>()
        addedVertices.insert(vertex)
        // 当最小堆不为空并且已经添加的顶点数量小于所有顶点数量
        while !heap.isEmpty && addedVertices.count < verticesSize {
            // 获取权值最小的边，即最小堆的根节点
            let edge = heap.remove()!
            // 判断这个边的toVertex是否已经被添加过3
            if addedVertices.contains(edge.toVertex) {
                continue
            }
            // 将该顶点的所有出边添加进最小堆
            heap.addElements(elements: Array(edge.toVertex.outEdges))
            addedVertices.insert(edge.toVertex)
            edgesInfo.append(edge.edgeInfo)
        } 
        return edgesInfo
    }
    
    
    /// 最小生成树Kruskal算法实现
    ///
    /// - Returns: 最小生成树的所有路径信息
    func kruskal() -> Array<EdgeInfo>? {
        // 如果图没有顶点，返回nil
        let edgesSize = edges.count
        if edgesSize == 0 {
            return nil
        }
        var edgesInfo = Array<EdgeInfo>()
        
        // 以所有的边创建最小堆
        let heap = BinaryHeap<Edge>.init()
        heap.isMax = false
        heap.heapify(elements: Array(edges))
        
        // 以所有顶点创建并查集
        let unionFind = GenericUnionFind<Vertex>.init()
        for vertex in vertices.values {
            unionFind.makeNode(nodeValue: vertex)
        }
        
        while !heap.isEmpty && edgesInfo.count < edgesSize {
            let edge = heap.remove()!
            // 如果边的两个顶点处于同一个并查集中
            if unionFind.isSame(lnv: edge.fromVertex, rnv: edge.toVertex) {
                continue
            }
            edgesInfo.append(edge.edgeInfo)
            unionFind.union(lnv: edge.fromVertex, rnv: edge.toVertex)
        }
        
        return edgesInfo
    }
    
    
    /// 获取单元最短路径的算法：Dijkstra
    ///
    /// - Parameters:
    ///   - vertex: 开始的顶点
    ///   - addWeightClosure: 边的权重相加闭包
    /// - Returns: 所有能到达的顶点的最短路径信息
    func dijkstra(vertex: V, addWeightClosure: (_ oldWeight: T, _ edgeWeight: T) -> T) -> Dictionary<V, PathInfo>? {
        // 如果顶点不存在
        guard let beginVertex = vertices[vertex] else {
            return nil
        }
        
        // 已经选择了的顶点，保存着最短的路径信息
        var selectedPaths = Dictionary<V, PathInfo>()
        // 正在进行操作的顶点，保存着当前操作的最短路径信息
        var paths = Dictionary<Vertex, PathInfo>()
        for edge in beginVertex.outEdges {
            let path = PathInfo.init(weight: edge.weight!, edges: [edge.edgeInfo])
            paths[edge.toVertex] = path
        }
        
        while !paths.isEmpty {
            // 找出路径最短的顶点
            let (minVertex, minPath) = getMinPath(paths: paths)
            selectedPaths[minVertex.value] = minPath
            paths.removeValue(forKey: minVertex)
            // 对minVertex进行松弛操作
            for edge in minVertex.outEdges {
                // 如果已经选出了最短路径
                if selectedPaths[edge.toVertex.value] != nil {
                    continue
                }
                relax(edge: edge, paths: &paths, minPath: minPath, addWeightClosure: addWeightClosure)
            }
        }
        selectedPaths.removeValue(forKey: beginVertex.value)
        return selectedPaths
    }
    
    
    /// 获取路径信息中的最短路径
    ///
    /// - Parameter paths: 保存着到达顶点的最短路径信息
    /// - Returns: 最短路径元组:(顶点， 路径信息)
    private func getMinPath(paths: Dictionary<Vertex, PathInfo>) -> (Vertex, PathInfo) {
        var vertex = paths.keys.first!
        var path = paths.values.first!
        for (key, value) in paths {
            if (value.weight < path.weight) {
                vertex = key
                path = value
            }
        }
        return (vertex, path)
    }
    
    
    /// 对某条边进行松弛操作
    ///
    /// - Parameters:
    ///   - edge: 松弛的边
    ///   - paths: 存放着其他点（对于dijkstra来说，就是还没有离开桌面的点）的最短路径信息
    ///   - minPath: 到edge的fromVertex的最短路径信息
    ///   - addWeightClosure: 边的权重相加闭包
    private func relax(edge: Edge, paths: inout Dictionary<Vertex, PathInfo>, minPath:PathInfo,
                       addWeightClosure: (_ oldWeight: T, _ edgeWeight: T) -> T) {
        let oldPath = paths[edge.toVertex]
        // 如果之前没有到达顶点的路径
        if oldPath == nil {
            let path = PathInfo.init(weight: addWeightClosure(minPath.weight, edge.weight!),
                                     edges: minPath.edgesInfo)
            path.edgesInfo.append(edge.edgeInfo)
            paths[edge.toVertex] = path
        } else {
            let newWeight = addWeightClosure(minPath.weight, edge.weight!)
            if (newWeight < oldPath!.weight) {
                oldPath!.weight = newWeight
                oldPath!.edgesInfo.removeAll()
                oldPath!.edgesInfo.append(contentsOf: minPath.edgesInfo)
                oldPath!.edgesInfo.append(edge.edgeInfo)
            }
        }
    }
    
    
    /// 获取单元最短路径的算法：BellmanFord
    ///
    /// - Parameters:
    ///   - beginVertex: 开始的顶点
    ///   - beginWeight: 开始顶点的权重
    ///   - addWeightClosure: 边的权重相加闭包
    /// - Returns: 所有能到达的顶点的最短路径信息
    func bellmanFord(beginVertex: V, beginWeight: T,
                     addWeightClosure: (_ oldWeight: T, _ edgeWeight: T) -> T) -> Dictionary<V, PathInfo>? {
        // 如果顶点不存在
        guard let beginVertex = vertices[beginVertex] else {
            return nil
        }
        
        // 保存最短的路径信息
        var selectedPaths = Dictionary<V, PathInfo>()
        let beginPath  = PathInfo.init(weight: beginWeight, edges: [])
        selectedPaths[beginVertex.value] = beginPath
        
        for _ in 0...vertices.count - 1 {
            for edge in edges {
                guard let fromPath = selectedPaths[edge.fromVertex.value] else {
                    continue
                }
                let _ = relaxForBellmanFord(edge: edge, paths: &selectedPaths, minPath: fromPath, addWeightClosure: addWeightClosure)
            }
        }
        
        for _ in 0...vertices.count - 1 {
            for edge in edges {
                guard let fromPath = selectedPaths[edge.fromVertex.value] else {
                    continue
                }
                // 假如此刻还可以松驰成功的话，那么就存在负权环，无法求出最短路径
                let flag = relaxForBellmanFord(edge: edge, paths: &selectedPaths, minPath: fromPath, addWeightClosure: addWeightClosure)
                if flag {
                    return nil
                }
            }
        }
        
        selectedPaths.removeValue(forKey: beginVertex.value)
        return selectedPaths
    }
    
    private func relaxForBellmanFord(edge: Edge, paths: inout Dictionary<V, PathInfo>, minPath:PathInfo,
                       addWeightClosure: (_ oldWeight: T, _ edgeWeight: T) -> T) -> Bool{
        let oldPath = paths[edge.toVertex.value]
        // 如果之前没有到达顶点的路径
        if oldPath == nil {
            let path = PathInfo.init(weight: addWeightClosure(minPath.weight, edge.weight!),
                                     edges: minPath.edgesInfo)
            path.edgesInfo.append(edge.edgeInfo)
            paths[edge.toVertex.value] = path
        } else {
            let newWeight = addWeightClosure(minPath.weight, edge.weight!)
            if (newWeight < oldPath!.weight) {
                oldPath!.weight = newWeight
                oldPath!.edgesInfo.removeAll()
                oldPath!.edgesInfo.append(contentsOf: minPath.edgesInfo)
                oldPath!.edgesInfo.append(edge.edgeInfo)
            } else {
                return false
            }
        }
        return true
    }
    
    func floyd(addWeightClosure: (_ oldWeight: T, _ edgeWeight: T) -> T) -> Dictionary<V, Dictionary<V, PathInfo>>? {
        // 初始化所有出发点和终点的路径信息
        var paths = Dictionary<V, Dictionary<V, PathInfo>>.init()
        var path: Dictionary<V, PathInfo>
        for edge in edges {
            let pathInfo = PathInfo.init(weight: edge.weight!, edges: [edge.edgeInfo])
            if paths[edge.fromVertex.value] == nil {
                path = Dictionary<V, PathInfo>.init()
            }
            else {
                path = paths[edge.fromVertex.value]!
            }
            path[edge.toVertex.value] = pathInfo
            paths[edge.fromVertex.value] = path
        }
        
        for (v2,value2) in vertices {
            for (v1,value1) in vertices {
                for (v3,value3) in vertices {
                    if value1 == value2 || value1 == value3 || value2 == value3 {
                        continue
                    }
                    guard let pathInfo12 = getPathInfo(vertexFrom: v1, vertexTo: v2, paths: paths) else {
                        continue
                    }
                    
                    guard let pathInfo23 = getPathInfo(vertexFrom: v2, vertexTo: v3, paths: paths) else {
                        continue
                    }
                    
                    let pathInfo13 = getPathInfo(vertexFrom: v1, vertexTo: v3, paths: paths)
                    let newWeight = addWeightClosure(pathInfo12.weight,pathInfo23.weight)
                    if pathInfo13 == nil {
                        let path13 = PathInfo.init(weight: newWeight, edges: pathInfo12.edgesInfo)
                        path13.edgesInfo.append(contentsOf: pathInfo23.edgesInfo)
                        var path = paths[v1]!
                        path[v3] = path13
                        paths[v1] = path
                    }
                    else {
                        let oldWeight = pathInfo13!.weight
                        if (oldWeight > newWeight) {
                            pathInfo13!.edgesInfo.removeAll()
                            pathInfo13!.edgesInfo.append(contentsOf: pathInfo12.edgesInfo)
                            pathInfo13!.edgesInfo.append(contentsOf: pathInfo23.edgesInfo)
                            pathInfo13!.weight = newWeight
                            var path = paths[v1]!
                            path[v3] = pathInfo13
                            paths[v1] = path
                        }
                    }
                }
            }
        }
        
        return paths
    }
    
    private func getPathInfo(vertexFrom: V, vertexTo: V, paths: Dictionary<V, Dictionary<V, PathInfo>>) -> PathInfo? {
        guard let path = paths[vertexFrom] else {
            return nil
        }
        return path[vertexTo]
    }
    
    func graphPrint() {
        print("顶点------------------")
        for (vertex,vertexObj) in vertices {
            print(vertex)
            print("出边------------------")
            print(vertexObj.outEdges)
            print("入边------------------")
            print(vertexObj.inEdges)
        }
    }
}

