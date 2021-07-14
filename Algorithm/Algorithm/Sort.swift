//
//  Sort.swift
//  Algorithm
//
//  Created by LHMacCoder on 2020/8/3.
//


import Foundation

func bubbleSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else {
        return array
    }
    
    var sortArray = array
    let count = sortArray.count

    
    // 两两比较，大者往上冒
    for i in 0...count - 1 {
        // 优化点：如果一轮下来没有发生交换，说明数组已经有序，可以返回结果
        var flag = false
        for j in 0..<count - i - 1 {
            if (sortArray[j] > sortArray[j + 1]) {
                sortArray.swapAt(j, j + 1)
                flag = true
            }
        }
        if (!flag) {
            return sortArray
        }
    }
    return sortArray
}

func selectionSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else {
        return array
    }
    var sortArray = array
    let count = sortArray.count

    // 假如i为最小值，遍历寻找最小值的下标，然后交换
    // 由于选择排序减少了交换次数，所以平均性能要优于冒泡排序，
    for i in 0...count - 1 {
        var minIndex = i
        for j in i...count - 1 {
            if (sortArray[j] < sortArray[minIndex]) {
                minIndex = j
            }
        }
        sortArray.swapAt(i, minIndex)
    }
    return sortArray
}

func heapSort<T: Comparable>(_ array: [T]) -> [T] {
    var sortArray = array
    var heapSize = sortArray.count
    guard heapSize > 1 else {
        return array
    }
    // 原地建堆
    for i in (0...(heapSize >> 1) - 1).reversed() {
        siftDown(&sortArray, i, heapSize)
    }
    while (heapSize > 1) {
        // 交换堆顶元素和尾部元素
        heapSize -= 1
        sortArray.swapAt(0, heapSize)
        
        // 对0位置进行siftDown（恢复堆的性质）
        siftDown(&sortArray, 0, heapSize)
    }
    return sortArray
}

fileprivate func siftDown<T: Comparable>(_ heap: inout [T], _ index: Int, _ heapSize: Int) {
    let element = heap[index]
    var mulIndex = index
    let half = heapSize >> 1
    while (mulIndex < half) { // index必须是非叶子节点
        // 默认是左边跟父节点比
        var childIndex = (mulIndex << 1) + 1
        var child = heap[childIndex]
        
        let rightIndex = childIndex + 1
        // 右子节点比左子节点大
        if (rightIndex < heapSize &&
            heap[rightIndex] > child) {
            childIndex = rightIndex
            child = heap[childIndex]
        }
        
        // 大于等于子节点
        if (element >= child) {
            break
        }
        
        heap[mulIndex] = child
        mulIndex = childIndex
    }
    heap[mulIndex] = element
}

func insertionSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else {
        return array
    }
    
    var sortArray = array
    let count = sortArray.count

    
    // 假设i之前的数据已经有序，遍历比较，不断选择合适的位置插入，直到数组开头
//    for i in 1..<count {
//        var cur = i
//        while (cur > 0 && sortArray[cur] < sortArray[cur - 1]) {
//            sortArray.swapAt(cur, cur - 1)
//            cur -= 1
//        }
//    }
//    return sortArray

    // 优化：减少交换次数
    // 类似于摸扑克牌，假设手上的牌是有序的，摸到一张牌后，找到合适的位置，将后面的数据
    // 全部后挪一位，然后在该位置插入
    for i in 1..<count {
        var cur = i
        let curValue = sortArray[i]
        while (cur > 0 && sortArray[cur - 1] > curValue) {
            sortArray[cur] = sortArray[cur - 1]
            cur -= 1
        }
        sortArray[cur] = curValue
    }
    return sortArray
}

func mergeSort<T: Comparable>(_ array: [T]) -> [T]{
    guard array.count > 1 else {
        return array
    }
    var mergeArray = array;
    mergeSort(&mergeArray, 0, mergeArray.count)
    return mergeArray
}

fileprivate func mergeSort<T: Comparable>(_ array: inout [T], _ begin: Int, _ end: Int) {
    guard end - begin >= 2 else {
        return
    }
    let mid = (end + begin) / 2
    // 分割
    mergeSort(&array, begin, mid)
    mergeSort(&array, mid, end)
    // 合并
    merge(&array, begin, mid, end)
}

fileprivate func merge<T: Comparable>(_ array: inout [T], _ begin: Int, _ mid: Int, _ end: Int) {
    // li：左半数组开始下标，le：左边数组结尾下标
    var li = 0, le = mid - begin
    // ri: 右边数组开始下标，re：右边数组结尾下标
    var ri = mid, re = end
    // 数组Array下标
    var ai = begin
    
    // 另存左半数组
    let subArray = Array(array[begin..<mid])
    
    // 当左半数组还没结束时
    while li < le {
        // 右半数组还没越界，并且左半数组大于右半数组，将右边数据覆盖左边
        if ri < re && subArray[li] > array[ri] {
            array[ai] = array[ri]
            ai += 1
            ri += 1
        }
        // 如果右半数组已经越界或者左边数组小于右边，直接将数据覆盖
        else {
            array[ai] = subArray[li]
            ai += 1
            li += 1
        }
    }
}

func quickSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else {
        return array
    }
    
    var sortArray = array
    quickSort(&sortArray, 0, array.count - 1)
    return sortArray
}

fileprivate func quickSort<T: Comparable>(_ array: inout [T], _ begin: Int, _ end: Int) {
    guard end - begin > 1 else {
        return
    }
    
    // 寻找轴点元素位置
    let mid = pivotIndex(&array, begin, end)
    
    // 对轴点左边元素快速排序
    quickSort(&array, begin, mid)
    // 对轴点右边元素快速排序
    quickSort(&array, mid + 1, end)
}

fileprivate func pivotIndex<T :Comparable>(_ array: inout [T], _ begin: Int, _ end: Int) -> Int {
    var beginIndex = begin
    var endIndex = end
    
    // 随机获取轴点元素, 避免最坏时间复杂度情况发生
    array.swapAt(beginIndex, Int.random(in: beginIndex...endIndex))
    let pivot = array[beginIndex]
    
    while beginIndex < endIndex {
        while beginIndex < endIndex {
            if (array[endIndex] < pivot) {
                array[beginIndex] = array[endIndex]
                beginIndex += 1
                break
            }
            else {
                endIndex -= 1
            }
        }
        
        while beginIndex < endIndex {
            if (array[beginIndex] > pivot) {
                array[endIndex] = array[beginIndex]
                endIndex -= 1
                break
            }
            else {
                beginIndex += 1
            }
        }
    }
    
    array[beginIndex] = pivot
    
    return beginIndex
}

func shellSort<T: Comparable>(_ array: [T]) -> [T] {
    let stepArray = shellStepArray(array.count)
    var sortArray = array
    // 遍历分组[1,2,4,8,16......],其中数字代表将数组分成多少列
    for step in stepArray {
        // 对每一列进行插入排序
        for i in (0..<step) {
            var begin = i + step
            while begin < sortArray.count {
                let curValue = sortArray[begin]
                var cur = begin
                while cur > i && curValue < sortArray[cur - step] {
                    sortArray[cur] = sortArray[cur - step]
                    cur -= step
                }
                sortArray[cur] = curValue
                begin += step
            }
        }
    }
    return sortArray
}

fileprivate func shellStepArray(_ count: Int) -> [Int] {
    var stepArray = [Int]()
    for i in 0...count {
        let step = count / 2 << i
        if step > 0 {
            stepArray.append(step)
        }
        else {
            break
        }
    }
    return stepArray
}
 
