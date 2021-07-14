//
//  main.swift
//  Algorithm
//
//  Created by LHMacCoder on 2021/7/5.
//

import Foundation

//var array = [2,3,5,1,7,44,6,8,456456,768678,2342,56758,24345,7564,-100,-999]
//print("bubble sort:             \(bubbleSort(array))")
//print("selectionSort sort:      \(selectionSort(array))")
//print("heapSort sort:           \(heapSort(array))")
//print("insertion sort:          \(insertionSort(array))")
//print("merge sort:              \(mergeSort(array))")
//print("quick sort:              \(quickSort(array))")
//print("shell sort:              \(shellSort(array))")
//
//var union = UnionFind.init(capacity: 10)
//print("before union:")
//print(union!)
//union?.unionQF(value1: 1, value2: 0)
//print(union!)
//union?.unionQF(value1: 1, value2: 2)
//print(union!)
//union?.unionQF(value1: 3, value2: 4)
//print(union!)
//union?.unionQF(value1: 0, value2: 3)
//print(union!)

//var unionG = GenericUnionFind<Int>.init()
//unionG.makeNode(nodeValue: 0)
//unionG.makeNode(nodeValue: 1)
//unionG.makeNode(nodeValue: 2)
//unionG.makeNode(nodeValue: 3)
//unionG.makeNode(nodeValue: 4)
//unionG.makeNode(nodeValue: 5)
//unionG.makeNode(nodeValue: 6)
//unionG.makeNode(nodeValue: 7)
//unionG.makeNode(nodeValue: 8)
//unionG.makeNode(nodeValue: 9)
//print("before union:")
//print(unionG)
//unionG.union(lnv: 1, rnv: 0)
//print(unionG)
//unionG.union(lnv: 1, rnv: 2)
//print(unionG)
//unionG.union(lnv: 3, rnv: 4)
//print(unionG)
//unionG.union(lnv: 0, rnv: 3)
//print(unionG)



//let graph = Graph<String, Int>.init()
//graph.addEdge(from: "V1", to: "V0", weight: 9)
//graph.addEdge(from: "V1", to: "V2", weight: 3)
//graph.addEdge(from: "V2", to: "V3", weight: 5)
//graph.addEdge(from: "V3", to: "V4", weight: 1)
//graph.addEdge(from: "V2", to: "V0", weight: 2)
//graph.addEdge(from: "V0", to: "V4", weight: 6)
//graph.addVertex(vertex: "V5")
//graph.removeVertex(vertex: "V0")
//graph.graphPrint()
//graph.addEdge(from: "a", to: "V1", weight: 9)
//graph.addEdge(from: "V0", to: "V4", weight: 9)
//graph.addEdge(from: "V2", to: "V0", weight: 3)
//graph.addEdge(from: "V1", to: "V2", weight: 5)
//graph.addEdge(from: "V3", to: "V1", weight: 1)
//graph.addEdge(from: "V2", to: "V5", weight: 2)
//graph.addEdge(from: "V2", to: "V4", weight: 6)
//graph.addEdge(from: "V4", to: "V6", weight: 9)
//graph.addEdge(from: "V4", to: "V7", weight: 3)
//graph.addEdge(from: "V5", to: "V3", weight: 5)
//graph.addEdge(from: "V5", to: "V7", weight: 1)
//graph.addEdge(from: "V6", to: "V2", weight: 2)
//graph.addEdge(from: "V6", to: "V1", weight: 6)
//graph.bfs(vertex: "V0") {
//    print($0)
//    return false
//}

//let graph1 = Graph<Int, Int>.init()
//graph1.addEdge(from: 0, to: 1, weight: nil)
//graph1.addEdge(from: 1, to: 0, weight: nil)
//
//graph1.addEdge(from: 1, to: 2, weight: nil)
//graph1.addEdge(from: 2, to: 1, weight: nil)
//
//graph1.addEdge(from: 1, to: 3, weight: nil)
//graph1.addEdge(from: 3, to: 1, weight: nil)
//
//graph1.addEdge(from: 1, to: 5, weight: nil)
//graph1.addEdge(from: 5, to: 1, weight: nil)
//
//graph1.addEdge(from: 1, to: 6, weight: nil)
//graph1.addEdge(from: 6, to: 1, weight: nil)
//
//graph1.addEdge(from: 2, to: 4, weight: nil)
//graph1.addEdge(from: 4, to: 2, weight: nil)
//
//graph1.addEdge(from: 3, to: 7, weight: nil)
//graph1.addEdge(from: 7, to: 3, weight: nil)
//
//graph1.dfs(vertex: 1) {
//    print($0)
//    return false
//}

//let graph2 = Graph<String, Int>.init()
//graph2.addEdge(from: "a", to: "e")
//graph2.addEdge(from: "a", to: "b")
//graph2.addEdge(from: "b", to: "e")
//graph2.addEdge(from: "c", to: "b")
//graph2.addEdge(from: "d", to: "a")
//graph2.addEdge(from: "e", to: "c")
//graph2.addEdge(from: "e", to: "f")
//graph2.addEdge(from: "f", to: "c")
//graph2.dfs(vertex: "a") {
//    print($0)
//    return false
//}

//let graph = Graph<String, Int>.init()
//graph.addEdge(from: "A", to: "B")
//graph.addEdge(from: "A", to: "D")
//graph.addEdge(from: "B", to: "F")
//graph.addEdge(from: "C", to: "B")
//graph.addEdge(from: "C", to: "F")
//graph.addEdge(from: "E", to: "A")
//graph.addEdge(from: "E", to: "B")
//graph.addEdge(from: "E", to: "F")
//print(graph.topologicalSort())


//let heap = BinaryHeap<Int>.init()
//heap.add(element: 68)
//heap.add(element: 72)
//heap.add(element: 43)
//heap.add(element: 50)
//heap.add(element: 38)
//heap.heapPrint()
//heap.add(element: 100)
//heap.heapPrint()
//let top = heap.replae(element: 1)
//heap.heapPrint()
//print(top)


//let graph = Graph<Int, Int>.init()
//graph.addEdge(from: 0, to: 2, weight: 2)
//graph.addEdge(from: 0, to: 4, weight: 7)
//graph.addEdge(from: 2, to: 0, weight: 2)
//graph.addEdge(from: 2, to: 1, weight: 3)
//graph.addEdge(from: 2, to: 6, weight: 6)
//graph.addEdge(from: 2, to: 5, weight: 3)
//graph.addEdge(from: 2, to: 4, weight: 4)
//graph.addEdge(from: 2, to: 4, weight: 4)
//graph.addEdge(from: 1, to: 2, weight: 3)
//graph.addEdge(from: 1, to: 6, weight: 7)
//graph.addEdge(from: 1, to: 5, weight: 1)
//graph.addEdge(from: 4, to: 0, weight: 7)
//graph.addEdge(from: 4, to: 2, weight: 4)
//graph.addEdge(from: 4, to: 6, weight: 8)
//graph.addEdge(from: 6, to: 5, weight: 4)
//graph.addEdge(from: 6, to: 2, weight: 6)
//graph.addEdge(from: 6, to: 4, weight: 8)
//graph.addEdge(from: 6, to: 1, weight: 7)
//graph.addEdge(from: 5, to: 6, weight: 4)
//graph.addEdge(from: 5, to: 1, weight: 1)
//graph.addEdge(from: 5, to: 2, weight: 3)
//graph.addEdge(from: 5, to: 7, weight: 5)
//graph.addEdge(from: 7, to: 5, weight: 5)
//graph.addEdge(from: 7, to: 3, weight: 9)
//graph.addEdge(from: 3, to: 7, weight: 9)
//print(graph.prim())
//print(graph.kruskal())

//let graph = Graph<String, Int>.init()
//graph.addEdge(from: "A", to: "B", weight: 17)
//graph.addEdge(from: "B", to: "A", weight: 17)
//graph.addEdge(from: "A", to: "F", weight: 1)
//graph.addEdge(from: "F", to: "A", weight: 1)
//graph.addEdge(from: "A", to: "E", weight: 16)
//graph.addEdge(from: "E", to: "A", weight: 16)
//graph.addEdge(from: "B", to: "F", weight: 11)
//graph.addEdge(from: "F", to: "B", weight: 11)
//graph.addEdge(from: "B", to: "D", weight: 5)
//graph.addEdge(from: "D", to: "B", weight: 16)
//graph.addEdge(from: "B", to: "C", weight: 6)
//graph.addEdge(from: "C", to: "B", weight: 6)
//graph.addEdge(from: "F", to: "E", weight: 33)
//graph.addEdge(from: "E", to: "F", weight: 33)
//graph.addEdge(from: "F", to: "D", weight: 14)
//graph.addEdge(from: "D", to: "F", weight: 14)
//graph.addEdge(from: "E", to: "D", weight: 4)
//graph.addEdge(from: "D", to: "E", weight: 4)
//graph.addEdge(from: "D", to: "C", weight: 10)
//graph.addEdge(from: "C", to: "D", weight: 10)
//print(graph.prim())
//print(graph.kruskal())

//let graph = Graph<String, Int>.init()
//graph.addEdge(from: "A", to: "B", weight: 10)
//graph.addEdge(from: "A", to: "E", weight: 100)
//graph.addEdge(from: "A", to: "D", weight: 30)
//graph.addEdge(from: "B", to: "C", weight: 50)
//graph.addEdge(from: "C", to: "E", weight: 10)
//graph.addEdge(from: "D", to: "C", weight: 20)
//graph.addEdge(from: "D", to: "E", weight: 60)

//graph.addEdge(from: "B", to: "A", weight: 10)
//graph.addEdge(from: "E", to: "A", weight: 100)
//graph.addEdge(from: "D", to: "A", weight: 30)
//graph.addEdge(from: "C", to: "B", weight: 50)
//graph.addEdge(from: "E", to: "C", weight: 10)
//graph.addEdge(from: "C", to: "D", weight: 20)
//graph.addEdge(from: "E", to: "D", weight: 60)

//print(graph.dijkstra(vertex: "A", addWeightClosure: {$0 + $1}) ?? 0)
//print(graph.bellmanFord(beginVertex: "A", beginWeight: 0, addWeightClosure: {$0 + $1}) ?? 0)
//print(graph.floyd(addWeightClosure: {$0 + $1}))


//let tree = BinarySearchTree<Int>.init()
//let array = [1, 4, 88, 85, 100, 61, 63, 21, 5, 9, 92, 59, 95, 47, 44, 26, 58, 13]
//for number in array {
//    tree.add(element: number)
//}
//tree.traversalClosure = { (element,stop) -> () in
//    if element == 61 {
//        stop = true
//    }
//    print(element)
//}
//print(tree.isCompleteTree())
//tree.remove(element: 67)
//print(tree.inorderTraversal())
//print(tree.preorderTraversal())
//tree.remove(element: 57)
//print(tree.inorderTraversal())
//print(tree.postorderTraversal())

//let avlTree = AVLTree<Int>.init()
//let array = [41, 97, 18, 61, 100, 80, 69, 76, 3, 78, 8, 33, 79, 75, 40]
//for number in array {
//    avlTree.add(element: number)
//}
//avlTree.traversalClosure = {print($0)}
//avlTree.add(element: 90)
//print(avlTree.preorderTraversal())
//print(avlTree.inorderTraversal())


//let rbTree = RBTree<Int>.init()
//let array = [33, 11, 55, 14, 24, 47, 78, 44, 27, 70, 86, 37, 97, 61, 74, 67, 99, 21, 28]
//for number in array {
//    rbTree.add(element: number)
//}
//rbTree.traversalClosure = { (element,stop) -> () in
//    print(element)
//}
//rbTree.remove(element: 97)
//rbTree.remove(element: 21)
//rbTree.remove(element: 28)
//rbTree.remove(element: 11)
//
//print(rbTree.preorderTraversal())

