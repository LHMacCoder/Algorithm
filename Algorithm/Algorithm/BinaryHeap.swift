//
//  BinaryHeap.swift
//  Algorithm
//
//  Created by LHMacCoder on 2020/10/26.
//  Copyright © 2020 LHMacCoder. All rights reserved.
//

import Foundation

/// 二叉堆：任意节点的值总是大于子节点的值，成为最大堆，
/// 任意节点的值总是小于子节点的值，称为最小堆
/// 堆的时间复杂度：获取最大最大值：O(1)，删除最大值：O(logn)m，添加元素：O(logn)
/// 二叉堆的逻辑结构就是一颗完全二叉树，所以也叫完全二叉堆
/// 鉴于完全二叉树的一些性质，二叉堆的底层一般用数组实现
///
/// 索引i的规律:
/// 如果i = 0，它是根节点
///
/// 如果i > 0，它的父节点编号为floor((i - 1) / 2)
///
/// 如果2i + 1 <= n - 1，它的左子节点编号为2i + 1
/// 如果2i + 1 > n - 1，它无左子节点
///
/// 如果2i + 2 <= n - 1，它的右子节点编号为2i + 2
/// 如果2i + 2 > n - 1，它无右子节点
class BinaryHeap<T: Comparable> {
    private var elements: [T]
    
    /// 是否是最大堆，默认true
    var isMax = true
    
    var size: Int {
        return elements.count
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    init() {
        elements = Array.init()
    }
    
    func clear() {
        elements.removeAll()
    }
    
    func add(element: T) {
        elements.append(element)
        siftUp(index: size - 1)
    }
    
    func addElements(elements: [T]) {
        for e in elements {
            self.elements.append(e)
            siftUp(index: size - 1)
        }
    }
    
    /// 批量建堆
    func heapify(elements: [T]) {
        self.elements = elements
//        /// 自上而下的上滤
//        for i in 0..<size {
//            siftUp(index: i)
//        }
        
        /// 自下而上的下滤,效率要比自上而下的上滤的要高，因为叶子节点无需操作
        for i in (0..<(size >> 1 - 1)).reversed() {
            siftDown(index: i)
        }
    }
    
    /// 最大最小堆上滤操作
    private func siftUp(index: Int) {
        var childIndex = index
        let element = elements[index]
        while childIndex > 0 {
            // 如果i > 0，它的父节点编号为floor((i - 1) / 2)
            let pIndex = (childIndex - 1) >> 1
            if isMax {
                if elements[pIndex] > element {
                    break
                }
            }
            else {
                if elements[pIndex] < element {
                    break
                }
            }
            elements[childIndex] = elements[pIndex]
            childIndex = pIndex
        }
        elements[childIndex] = element
    }
    
    /// 获取堆顶元素
    func get() -> T? {
        return elements.last
    }
    
    /// 删除堆顶元素
    func remove() -> T? {
        if isEmpty {
            return nil
        }
        let e = elements.first
    
        elements.swapAt(0, size - 1)
        elements.removeLast()
        if isEmpty {
            return e
        }
        siftDown(index: 0)
        return e
    }
    
    private func siftDown(index: Int) {
        // 两个关键点：
        // 1.第一个叶子节点的下标 == 非叶子节点的数量 == 总节点数 / 2
        // 2.只需要对非叶子节点进行下滤操作
        let half = size >> 1
        var nodeIndex = index
        let element = elements[nodeIndex]
        // 保证子节点存在
        while nodeIndex < half {
            // 优先左子节点比较，因为右子节点可能不存在
            // 获取左子节点下标：左子节点编号为2i + 1
            let leftIndex = nodeIndex << 1 + 1
            let leftChild = elements[leftIndex]
            let rightIndex = leftIndex + 1
            
            // 如果右节点存在,选出较大的节点
            var childNode = leftChild
            var childIndex = leftIndex

            if isMax {
                if rightIndex < size && elements[rightIndex] > leftChild {
                    childNode = elements[rightIndex]
                    childIndex = rightIndex
                }
                // 如果大于子节点，那么已经是最大堆，退出循环
                if childNode <= element {
                    break
                }
            }
            else {
                if rightIndex < size && elements[rightIndex] < leftChild {
                    childNode = elements[rightIndex]
                    childIndex = rightIndex
                }
                // 如果小于子节点，那么已经是最小堆，退出循环
                if childNode >= element {
                    break
                }
            }
            
            elements[nodeIndex] = childNode
            nodeIndex = childIndex
        }
        elements[nodeIndex] = element
    }
    
    /// 删除堆顶元素的同时插入新元素
    func replae(element: T) -> T? {
        if isEmpty {
            return nil
        }
        let e = elements[0]
        elements[0] = element
        siftDown(index: 0)
        return e
    }
    
    func heapPrint() {
        print(elements)
    }
}
