//
//  BinarySearchTree.swift
//  Algorithm
//
//  Created by LHMacCoder on 2020/12/24.
//  Copyright © 2020 LHMacCoder. All rights reserved.
//

import Foundation

/// 节点Node
fileprivate class Node<E: Comparable & Equatable>: Equatable {
    
    var element: E
    var leftNode: Node?
    var rightNode: Node?
    var parentNode: Node?
    init(element: E, parent: Node?) {
        self.element = element
        parentNode = parent
    }
    
    func isLeftChild() -> Bool {
        return self == parentNode?.leftNode
    }
    
    func isRightChild() -> Bool {
        return self == parentNode?.rightNode
    }
    
    func sibling() -> Node? {
        if isLeftChild() {
            return parentNode?.rightNode
        }
        if isRightChild() {
            return parentNode?.leftNode
        }
        
        return nil
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.element == rhs.element
    }
}


/// 二叉搜索树
class BinarySearchTree<E: Comparable & Equatable> {
    
    /// 节点的个数
    var size: Int = 0
    
    var isEmpty: Bool {
        return size == 0
    }
    
    /// 树的高度
    var height: Int {
        guard let rootNode = root else {
            return 0
        }
        return height(element: rootNode.element)
    }
    
    /// 根节点
    fileprivate var root: Node<E>?
    
    /// 遍历闭包
    var traversalClosure: ((_ element: E, _ stop: inout Bool) -> ())?
    
    /// 创建节点
    ///
    /// - Parameters:
    ///   - element: 节点元素
    ///   - parent: 父节点
    /// - Returns: 新创建的节点
    fileprivate func createNode(element: E, parent: Node<E>?) -> Node<E>? {
        return Node.init(element: element, parent: parent)
    }
    
    /// 添加一个节点
    ///
    /// - Parameter element: 节点元素
    func add(element:E) {
        // 如果树为空，创建根节点
        guard let rootNode = root else {
            root = createNode(element: element, parent: nil)
            size += 1
            return
        }
        
        var node: Node? = rootNode
        var parentNode: Node = rootNode
        // 是否在左边插入
        var insertLeft = false
        
        while node != nil {
            parentNode = node!
            // 如果比节点的元素大，往右遍历
            if (element > node!.element) {
                node = node!.rightNode
                insertLeft = false
            }
            // 如果比节点的元素小，往左遍历
            else if (element < node!.element) {
                node = node!.leftNode
                insertLeft = true
            }
            else { // 如果相等，替换节点元素
                parentNode.element = element
                return
            }
        }
        
        // 创建新插入的元素的节点
        let newNode = createNode(element: element, parent: parentNode)
        if insertLeft {
            parentNode.leftNode = newNode
        }
        else {
            parentNode.rightNode = newNode
        }
        size += 1
        
        // 插入后的操作
        afterAdded(node: newNode!)
    }
    
    /// 添加新节点后的操作，AVL树恢复平衡
    ///
    /// - Parameter node: 新增节点
    fileprivate func afterAdded(node: Node<E>) {
        
    }
    
    /// 删除节点
    ///
    /// - Parameter element: 需要删除的节点元素值
    func remove(element: E) {
        // 首先判断这个元素的节点是否存在
        guard var node = node(element: element) else {
            return
        }
        size -= 1
        // 如果节点的度为2，根据中序遍历的结果，删除的节点可以用前驱或者后继节点来代替
        if node.rightNode != nil, node.leftNode != nil {
            if let sucNode = successor(node: node) {
                node.element = sucNode.element
                node = sucNode
            }
        }
        // 后继节点的度，必定为1或者0
        // 找出代替的节点
        let replaceNode = node.rightNode != nil ? node.rightNode : node.leftNode
        // 如果节点的度为1
        //          |
        //         node
        //        /    \
        //       nil  replaceNode
        //              / \
        //             ?   ?
        if replaceNode != nil {
            replaceNode?.parentNode = node.parentNode
            if node.parentNode == nil {
                // node为根节点
                root = replaceNode
            }
            else if node == node.parentNode?.leftNode {
                node.parentNode?.leftNode = replaceNode
            }
            else {
                node.parentNode?.rightNode = replaceNode
            }
            afterRemoved(node: node, replaceNode: replaceNode)
        }
        // 如果节点的度为0.直接删除
        // 根节点
        else if node.parentNode == nil {
            root = nil
            afterRemoved(node: node, replaceNode: nil)
        }
        else { // 非根节点
            if node == node.parentNode?.leftNode {
                node.parentNode?.leftNode = nil
            }
            else {
                node.parentNode?.rightNode = nil
            }
            afterRemoved(node: node, replaceNode: nil)
        }
    }
    
    /// 删除节点后的操作，AVL树恢复平衡
    ///
    /// - Parameter node: 删除的节点
    fileprivate func afterRemoved(node: Node<E>, replaceNode: Node<E>?) {
        
    }
    
    /// 获取元素所在的节点
    ///
    /// - Parameter element: 元素值
    /// - Returns: 节点
    fileprivate func node(element: E) -> Node<E>? {
        if root == nil {
            return nil
        }
        
        var node: Node? = root!
        while node != nil {
            if node!.element == element {
                return node
            }
            else if node!.element < element {
                node = node!.rightNode
            }
            else {
                node = node!.leftNode
            }
        }
        return nil
    }
    
    /// 前序遍历
    func preorderTraversal() {
        guard let rootNode = root else {
            return
        }
        preorderTraversal(node: rootNode)

    }
    
    fileprivate func preorderTraversal(node: Node<E>?) {
        guard let n = node else {
            return
        }
        var stackArray = Array<Node<E>>.init()
        stackArray.append(n)
        
        var stop = false
        var pNode: Node? = n
        while pNode != nil && !stackArray.isEmpty {
            if stop {
                return
            }
            if let rbNode = pNode as? RBNode {
                if rbNode.color == NodeColor.Red {
                    print("red: \(rbNode.element)")
                }
            }
            traversalClosure?(pNode!.element,&stop)
            if let right = pNode?.rightNode {
                stackArray.append(right)
            }
            
            if let left = pNode?.leftNode {
                stackArray.append(left)
            }
            
            pNode = stackArray.removeLast()
        }
    }
    
    /// 中序遍历
    func inorderTraversal() {
        guard let rootNode = root else {
            return
        }
        inorderTraversal(node: rootNode)
    }
    
    fileprivate func inorderTraversal(node: Node<E>?) {
        guard let n = node else {
            return
        }
        var stackArray = Array<Node<E>>.init()

        var pNode: Node? = n
        var stop = false
        while pNode != nil || !stackArray.isEmpty {
            
            while pNode != nil {
                stackArray.append(pNode!)
                pNode = pNode?.leftNode
            }
            
            if !stackArray.isEmpty {
                pNode = stackArray.removeLast()
                if stop {
                    return
                }
                traversalClosure?(pNode!.element,&stop)
                pNode = pNode?.rightNode
            }
        }
    }
    
    /// 后序遍历
    func postorderTraversal() {
        guard let rootNode = root else {
            return
        }
        postorderTraversal(node: rootNode)
    }
    
    fileprivate func postorderTraversal(node: Node<E>?) {
        guard let n = node else {
            return
        }
        var stackArray = Array<Node<E>>.init()
        var total = Array<Node<E>>.init()

        var pNode: Node? = n
        var stop = false
        while pNode != nil || !stackArray.isEmpty {
            
            while pNode != nil {
                stackArray.append(pNode!)
                total.append(pNode!)
                
                pNode = pNode?.rightNode
            }
            
            if !stackArray.isEmpty {
                pNode = stackArray.removeLast()
                pNode = pNode?.leftNode
            }
        }
        
        for e in total.reversed() {
            if stop {
                return
            }
            traversalClosure?(e.element,&stop)
        }
    }
    
    /// 层序遍历
    func levelorderTraversal() {
        guard let rootNode = root else {
            return
        }
        var stop = false
        var stackArray = Array<Node<E>>.init()
        stackArray.append(rootNode)
        while !stackArray.isEmpty {
            let node = stackArray.removeFirst()
            if stop {
                return
            }
            traversalClosure?(node.element,&stop)
            
            if let leftNode = node.leftNode {
                stackArray.append(leftNode)
            }
            
            if let rightNode = node.rightNode {
                stackArray.append(rightNode)
            }
        }
    }
    
    /// 翻转二叉树
    func invertTree() {
        guard let rootNode = root else {
            return
        }
        
        var stackArray = Array<Node<E>>.init()
        stackArray.append(rootNode)
        while !stackArray.isEmpty {
            let node = stackArray.removeFirst()
            
            let temp = node.rightNode
            node.rightNode = node.leftNode
            node.leftNode = temp
            
            if let leftNode = node.leftNode {
                stackArray.append(leftNode)
            }
            
            if let rightNode = node.rightNode {
                stackArray.append(rightNode)
            }
        }
    }
    
    /// 某个元素所在节点的高度
    ///
    /// - Parameter element: 元素值
    /// - Returns: 高度
    func height(element: E) -> Int {
        guard let rootNode = node(element: element) else {
            return 0
        }
        
        var height = 0
        // 每层节点的个数
        var levelSize = 1
        var stackArray = Array<Node<E>>.init()
        stackArray.append(rootNode)
        while !stackArray.isEmpty {
            let node = stackArray.removeFirst()
            levelSize -= 1
            
            if let leftNode = node.leftNode {
                stackArray.append(leftNode)
            }
            
            if let rightNode = node.rightNode {
                stackArray.append(rightNode)
            }
            
            // 如果每层节点的个数减为0之后，证明该层已经遍历完了
            // 这时队列的大小就是下一层的节点个数
            if  levelSize == 0 {
                height += 1
                levelSize = stackArray.count
            }
        }
        
        return height
    }
    
    /// 判断是否为完全二叉树
    ///
    /// - Returns: 是否为完全二叉树
    func isCompleteTree() -> Bool {
        guard let rootNode = root else {
            return false
        }
        var stackArray = Array<Node<E>>.init()
        // 是否出现只有左子节点的节点
        var leafNode = false
        stackArray.append(rootNode)
        while !stackArray.isEmpty {
            let node = stackArray.removeFirst()
            // 如果已经出现了只有左叶子节点的节点，并且当前遍历的节点又不是叶子节点
            // 那么这颗树就不是完全二叉树
            if leafNode, !isLeafNode(node: node){
                return false
            }
            
            if let leftNode = node.leftNode, let rightNode = node.rightNode{
                stackArray.append(leftNode)
                stackArray.append(rightNode)
                continue
            }
            
            // 如果只有右子节点
            if node.leftNode == nil, node.rightNode != nil {
                return false
            }
            
            if node.leftNode != nil, node.rightNode == nil {
                stackArray.append(node.leftNode!)
                // 此节点必须为叶子节点 
                leafNode = true
            }
        }
        return true
    }
    
    /// 前驱元素，中序遍历的前一个节点
    ///
    /// - Parameter element: 节点元素
    /// - Returns: 前驱元素
    func precursor(element: E) -> E? {
        guard let node = node(element: element) else {
            return nil
        }
        
        // node.left != nil
        // 一直往右寻找，直到右子节点不存在
        if var n = node.leftNode {
            while n.rightNode != nil {
                n = n.rightNode!
            }
            return n.element
        }
        
        // node.left == nil, node.parent != nil，前驱节点在父节点当中
        var p = node
        // 当p的父节点不为空，并且p是p的父节点的左子节点，继续往上遍历父节点
        //
        //               |
        //         p.parentNode
        //           /       \
        //          p         nil
        //         /
        //        nil
        while p.parentNode != nil, p == p.parentNode?.leftNode {
            p = p.parentNode!
        }
        // p为其父节点的右子节点，所以p的父节点即为element前驱节点
        // p.parentNode == nil, 没有前驱节点
        return p.parentNode?.element
    }
    
    /// 前驱节点，中序遍历的前一个节点
    ///
    /// - Parameter element: 节点
    /// - Returns: 前驱节点
    fileprivate func precursorNode(node: Node<E>) -> Node<E>? {
        // node.left != nil
        if var n = node.leftNode {
            while n.rightNode != nil {
                n = n.rightNode!
            }
            return n
        }
        
        // node.left == nil, node.parent != nil，前驱节点在父节点当中
        var p = node
        while p.parentNode != nil, p == p.parentNode?.leftNode {
            p = p.parentNode!
        }
        // p为其父节点的右子节点，所以p的父节点即为element前驱节点
        // p.parentNode == nil, 没有前驱节点
        return p.parentNode
    }
    
    /// 后继节点，中序遍历的后一个节点
    ///
    /// - Parameter element: 元素
    /// - Returns: 后继元素
    func successor(element: E) -> E? {
        guard let node = node(element: element) else {
            return nil
        }
        
        // node.right != nil
        // 一直往左寻找，直到左子节点不存在
        if var n = node.rightNode {
            while n.leftNode != nil {
                n = n.leftNode!
            }
            return n.element
        }
        
        // node.right == nil, node.parent != nil，后继节点在父节点当中
        var p = node
        // 当p的父节点不为空，并且p是p的父节点的右子节点，继续往上遍历父节点
        //
        //               |
        //         p.parentNode
        //           /       \
        //          nil       p
        //                     \
        //                      nil
        while p.parentNode != nil, p == p.parentNode?.rightNode {
            p = p.parentNode!
        }
        // p为其父节点的左子节点，所以p的父节点即为element后继节点
        // p.parentNode == nil, 没有后继节点
        return p.parentNode?.element
    }
    
    fileprivate func successor(node: Node<E>) -> Node<E>? {
        // node.right != nil
        if var n = node.rightNode {
            while n.leftNode != nil {
                n = n.leftNode!
            }
            return n
        }
        
        // node.right == nil, node.parent != nil，后继节点在父节点当中
        var p = node
        while p.parentNode != nil, p == p.parentNode?.rightNode {
            p = p.parentNode!
        }
        // p为其父节点的左子节点，所以p的父节点即为element后继节点
        // p.parentNode == nil, 没有后继节点
        return p.parentNode
    }
    
    
    /// 是否是叶子节点
    ///
    /// - Parameter node: 节点
    /// - Returns: 是否是叶子节点
    fileprivate func isLeafNode(node: Node<E>) -> Bool {
        return node.leftNode == nil && node.rightNode == nil
    }
    
    
    /// 如果是RBTree，将节点染成红色
    ///
    /// - Parameter node: 节点
    fileprivate func redNode(node: Node<E>) {
        if let colorNode = node as? RBNode {
            colorNode.color = .Red
        }
    }
    
    /// 如果是RBTree，将节点染成黑色
    ///
    /// - Parameter node: 节点
    fileprivate func blackNode(node: Node<E>) {
        if let colorNode = node as? RBNode {
            colorNode.color = .Black
        }
    }
    
    fileprivate func colorNode(_ node: Node<E>?, _ color: NodeColor) {
        if let colorNode = node as? RBNode {
            colorNode.color = color
        }
    }
    
    
    func clear() {
        root = nil
        size = 0
    }
}


/// 平衡二叉搜索树
class BBSTree<E: Comparable & Equatable>: BinarySearchTree<E> {
    /// 右旋
    fileprivate func rotateRight(grandNode: Node<E>) {
        let parent = grandNode.leftNode!
        let child = parent.rightNode
        
        parent.rightNode = grandNode
        grandNode.leftNode = child
        
        afterRotate(grandNode, parent, child)
    }
    
    /// 左旋
    fileprivate func rotateLeft(grandNode: Node<E>) {
        let parent = grandNode.rightNode!
        let child = parent.leftNode
        
        parent.leftNode = grandNode
        grandNode.rightNode = child
        
        afterRotate(grandNode, parent, child)
    }
    
    fileprivate func afterRotate(_ grandNode: Node<E>, _ parent: Node<E>, _ child: Node<E>?) {
        parent.parentNode = grandNode.parentNode
        if grandNode.isLeftChild() {
            grandNode.parentNode?.leftNode = parent
        }
        else if grandNode.isRightChild() {
            grandNode.parentNode?.rightNode = parent
        }
        else {
            // 根节点
            root = parent
        }
        
        grandNode.parentNode = parent
        child?.parentNode = grandNode
    }
    
    /// 统一所有的旋转操作(**统一所有的旋转操作.png**)
    ///
    /// - Parameters:
    ///   - r: 子树根节点
    ///   - b: 节点b
    ///   - c: 节点c
    ///   - d: 节点d
    ///   - e: 节点e
    ///   - f: 节点f
    fileprivate func rotate(_ r: Node<E>, _ b: Node<E>, _ c: Node<E>?, _ d: Node<E>,
                            _ e: Node<E>?, _ f: Node<E>) {
        d.parentNode = r.parentNode
        if r.isLeftChild() {
            r.parentNode?.leftNode = d
        }
        else if r.isRightChild() {
            r.parentNode?.rightNode = d
        }
        else {
            root = d
        }
        
        b.parentNode = d
        b.rightNode = c
        c?.parentNode = b
        
        f.parentNode = d
        f.leftNode = e
        e?.parentNode = f

        d.leftNode = b
        d.rightNode = f
        b.parentNode = d
        f.parentNode = d
    }
}

// 使用继承而不是扩展的原因是：AVL Tree的属性只在AVL Tree中，而不需要在Binary Search Tree中
class AVLTree<E: Comparable & Equatable>: BBSTree<E> {
    
    /// 创建新节点
    ///
    /// - Parameters:
    ///   - element: 节点元素
    ///   - parent: 父节点
    /// - Returns: 新节点
    fileprivate override func createNode(element: E, parent: Node<E>?) -> Node<E>? {
        return AVLNode.init(element: element, parent: parent)
    }
    
    /// 添加新节点后恢复平衡
    ///
    /// - Parameter node: 新节点
    fileprivate override func afterAdded(node: Node<E>) {
        var avlNode: AVLNode? = node.parentNode as? AVLNode<E>
        // 向上判断节点是否平衡，不平衡恢复平衡，平衡更新节点高度
        while avlNode != nil {
            if isBalance(node: avlNode!) {
                // 更新高度
                avlNode?.updateHeight()
            }
            else {
                // 恢复平衡
                rebalance(grandNode: avlNode!)
                break
            }
            avlNode = avlNode?.parentNode as? AVLNode<E>
        }
    }
    
    /// 删除节点后恢复平衡
    ///
    /// - Parameter node: 删除的节点
    fileprivate override func afterRemoved(node: Node<E>, replaceNode: Node<E>?) {
        var avlNode: AVLNode? = node.parentNode as? AVLNode<E>
        // 向上判断节点是否平衡，不平衡恢复平衡，平衡更新节点高度
        while avlNode != nil {
            if isBalance(node: avlNode!) {
                // 更新高度
                avlNode?.updateHeight()
            }
            else {
                // 恢复平衡
                rebalance(grandNode: avlNode!)
            }
            avlNode = avlNode?.parentNode as? AVLNode<E>
        }
    }
    
    fileprivate func isBalance(node: AVLNode<E>) -> Bool {
        return abs(node.balanceFactor) <= 1
    }
    
    fileprivate func rebalance(grandNode: AVLNode<E>) {
        let parentNode = grandNode.tallerChild()
        let node = parentNode.tallerChild()
        if parentNode.isLeftChild() { // L
            if node.isLeftChild() { // L
                rotateRight(grandNode: grandNode)
            }
            else { // R
                // 先左旋，再右旋
                rotateLeft(grandNode: parentNode)
                rotateRight(grandNode: grandNode)
            }
        }
        else { // R
            if node.isRightChild() { // R
                rotateLeft(grandNode: grandNode)
            }
            else { // L
                // 先右旋，再左旋
                rotateRight(grandNode: parentNode)
                rotateLeft(grandNode: grandNode)
            }
        }
    }
    
    fileprivate override func afterRotate(_ grandNode: Node<E>, _ parent: Node<E>, _ child: Node<E>?) {
        super.afterRotate(grandNode, parent, child)
        
        // 更新节点高度
        (grandNode as? AVLNode)?.updateHeight()
        (parent as? AVLNode)?.updateHeight()
    }
    
    fileprivate func uniteRotate(grandNode: AVLNode<E>) {
        let parentNode = grandNode.tallerChild()
        let node = parentNode.tallerChild()
        if parentNode.isLeftChild() { // L
            if node.isLeftChild() { // L
                rotate(grandNode, node, node.rightNode, parentNode, parentNode.rightNode, grandNode)
            }
            else { // R
                rotate(grandNode, parentNode, node.leftNode, node, node.rightNode, grandNode)
            }
        }
        else { // R
            if node.isRightChild() { // R
                rotate(grandNode, grandNode, parentNode.leftNode, parentNode, node.leftNode, node)
            }
            else { // L
                rotate(grandNode, grandNode, node.leftNode, node, node.rightNode, parentNode)
            }
        }
    }
    
    fileprivate override func rotate(_ r: Node<E>, _ b: Node<E>, _ c: Node<E>?, _ d: Node<E>, _ e: Node<E>?, _ f: Node<E>) {
        super.rotate(r, b, c, d, e, f)
        (b as! AVLNode).updateHeight()
        (f as! AVLNode).updateHeight()
        (d as! AVLNode).updateHeight()
    }
}

fileprivate class AVLNode<E: Comparable & Equatable>: Node<E> {
    var height: Int = 1
    
    /// 平衡因子
    var balanceFactor: Int {
        let leftHeight = leftNode == nil ? 0 : (leftNode as! AVLNode).height
        let rightHeight = rightNode == nil ? 0 : (rightNode as! AVLNode).height
        return leftHeight - rightHeight
    }
    
    func updateHeight() {
        let leftHeight = leftNode == nil ? 0 : (leftNode as! AVLNode).height
        let rightHeight = rightNode == nil ? 0 : (rightNode as! AVLNode).height
        height = 1 + max(leftHeight, rightHeight)
    }
    
    func tallerChild() -> AVLNode {
        let leftHeight = leftNode == nil ? 0 : (leftNode as! AVLNode).height
        let rightHeight = rightNode == nil ? 0 : (rightNode as! AVLNode).height
        if leftHeight > rightHeight {
            return leftNode as! AVLNode
        }
        else if leftHeight < rightHeight {
            return rightNode as! AVLNode
        }
        // 如果高度相等，返回和自己同方向的子节点，以降低后续旋转的复杂性
        return isLeftChild() ? leftNode as! AVLNode : rightNode as! AVLNode
    }
}

class RBTree<E: Comparable & Equatable>: BBSTree<E> {
    /// 创建新节点
    ///
    /// - Parameters:
    ///   - element: 节点元素
    ///   - parent: 父节点
    /// - Returns: 新节点
    fileprivate override func createNode(element: E, parent: Node<E>?) -> Node<E>? {
        return RBNode.init(element: element, parent: parent)
    }
    
    /// 添加新节点后恢复红黑树性质
    ///
    /// - Parameter node: 新节点
    fileprivate override func afterAdded(node: Node<E>) {
        let newNode = node as! RBNode
        let parent = node.parentNode as? RBNode
        
        if parent == nil {
            newNode.color = .Black
            return
        }
        
        let parentNode = parent!
        if parentNode.color == NodeColor.Black {
            return
        }
        
        // 叔父节点
        let uncleNode = parentNode.sibling() as? RBNode
        // 祖父节点
        let grandNode = parentNode.parentNode as? RBNode
        grandNode?.color = .Red

        if uncleNode?.color == NodeColor.Red {
            parentNode.color = .Black
            uncleNode?.color = .Black
            if let grand = grandNode {
                afterAdded(node: grand)
            }
            return
        }
        
        if parentNode.isLeftChild() { // L
            if newNode.isLeftChild() { // L
                parentNode.color = .Black
            }
            else { // R
                // 先左旋，再右旋
                newNode.color = .Black
                rotateLeft(grandNode: parentNode)
            }
            if let grand = grandNode {
                rotateRight(grandNode: grand)
            }
        }
        else { // R
            if node.isRightChild() { // R
                parentNode.color = .Black
            }
            else { // L
                // 先右旋，再左旋
                newNode.color = .Black
                rotateRight(grandNode: parentNode)
            }
            if let grand = grandNode {
                rotateLeft(grandNode: grand)
            }
        }
    }
    
    /// 删除节点后恢复红黑树性质
    ///
    /// - Parameter node: 删除的节点
    fileprivate override func afterRemoved(node: Node<E>, replaceNode: Node<E>?) {
        // 如果删除的红色节点，直接删除
        if isRed(node: node) {
            return
        }
        
        // 如果代替的节点颜色为红色，染为黑色
        if isRed(node: replaceNode) {
            colorNode(replaceNode, .Black)
            return
        }
        
        let parentNode = node.parentNode
        
        // 删除的是根节点
        if parentNode == nil {
            return
        }
        
        // 判断删除的节点是左节点还是右节点
        let left = parentNode?.leftNode == nil || node.isLeftChild()
        // 如果左节点为空，兄弟节点是右节点，如果左节点不为空，兄弟节点是左节点
        if var siblingNode = left ? parentNode?.rightNode : parentNode?.leftNode {
            if left {
                if isRed(node: siblingNode) {
                    // 兄弟节点是红色
                    colorNode(siblingNode, .Black)
                    colorNode(parentNode, .Red)
                    rotateLeft(grandNode: parentNode!)
                    siblingNode = parentNode!.rightNode!
                }
                
                // 兄弟节点没有一个红色子节点
                if isBlack(node: siblingNode.leftNode) &&
                    isBlack(node: siblingNode.rightNode) {
                    let black = isBlack(node: parentNode)
                    colorNode(siblingNode, .Red)
                    colorNode(parentNode, .Black)
                    // 如果父节点是黑色
                    if black {
                        afterRemoved(node: parentNode!, replaceNode: nil)
                    }
                }
                else { // 至少有一个红色子节点
                    // 如果sibling左子节点为空
                    if isBlack(node: siblingNode.rightNode) {
                        rotateRight(grandNode: siblingNode)
                        siblingNode = parentNode!.rightNode!
                    }
                    
                    colorNode(siblingNode, colorOf(node: parentNode))
                    colorNode(parentNode, .Black)
                    colorNode(siblingNode.rightNode, .Black)
                    rotateLeft(grandNode: parentNode!)
                }
            }
            else {
                if isRed(node: siblingNode) {
                    // 兄弟节点是红色
                    colorNode(siblingNode, .Black)
                    colorNode(parentNode, .Red)
                    rotateRight(grandNode: parentNode!)
                    siblingNode = parentNode!.leftNode!
                }
                
                // 兄弟节点没有一个红色子节点
                if isBlack(node: siblingNode.leftNode) &&
                    isBlack(node: siblingNode.rightNode) {
                    let black = isBlack(node: parentNode)
                    colorNode(siblingNode, .Red)
                    colorNode(parentNode, .Black)
                    // 如果父节点是黑色
                    if black {
                        afterRemoved(node: parentNode!, replaceNode: nil)
                    }
                }
                else { // 至少有一个红色子节点
                    // 如果sibling左子节点为空
                    if isBlack(node: siblingNode.leftNode) {
                        rotateLeft(grandNode: siblingNode)
                        siblingNode = parentNode!.leftNode!
                    }
                    
                    colorNode(siblingNode, colorOf(node: parentNode))
                    colorNode(parentNode, .Black)
                    colorNode(siblingNode.leftNode, .Black)
                    rotateRight(grandNode: parentNode!)
                }
            }
        }
    }
    
    fileprivate func colorOf(node: Node<E>?) -> NodeColor {
        return node == nil ? NodeColor.Black : (node as! RBNode).color
    }
    
    fileprivate func isBlack(node: Node<E>?) -> Bool {
        return colorOf(node: node as? RBNode) == NodeColor.Black
    }
    
    fileprivate func isRed(node: Node<E>?) -> Bool {
        return colorOf(node: node as? RBNode) == NodeColor.Red
    }
}

enum NodeColor {
    case Black
    case Red
}

fileprivate class RBNode<E: Comparable & Equatable>: Node<E> {
    var color: NodeColor = .Red
}
