//
//  main.swift
//  CopyOnWrite
//
//  Created by min Lee  on 2024/1/8.
//  Copyright © 2024 min Lee. All rights reserved.
//

import Foundation

/// 打印地址
func address(of object: UnsafeRawPointer) {
    let addr = Int(bitPattern: object)
    print(String(format: "%p", addr))
}

//var str1 = "1234"
//var str2 = str1
//address(of: &str1)  //0x100008108
//address(of: &str2)  //0x100008118

//var num1 = 5
//var num2 = num1
//address(of: &num1)  //0x100008128
//address(of: &num2)  //0x100008130

//var arr1 = [1,2,3,4]
//var arr2 = arr1

//修改前，arr1和arr2地址一样
//address(of: &arr1)   //0x600001708420
//address(of: &arr2)   //0x600001708420

//对arr2进行修改
//arr2[2] = 0

//修改arr2后，arr2地址变了
//address(of: &arr1)   //0x600001708420
//address(of: &arr2)   //0x600001708460

//struct MyStruct {
//    var data: [Int]
//}

//var obj1 = MyStruct(data: [1, 2, 3])
//var obj2 = obj1

//address(of: &obj1)  //0x100008148
//address(of: &obj2)  //0x100008150

//obj2.data[0] = 100

//address(of: &obj1)  //0x100008148
//address(of: &obj2)  //0x100008150


/*
 避免类的继承：将 Ref<T> 类定义为 final 可以防止其他类继承它。由于 Ref<T> 类是用于支持 Box<T> 结构体的内部实现，而不是作为可继承的基类，因此将其定义为 final 可以确保它不会被错误地继承和扩展。
 保持引用计数的一致性：Ref<T> 类使用 isKnownUniquelyReferenced(_:) 函数来检查引用计数，以确定是否需要进行复制。如果 Ref<T> 类是可继承的，其他子类可能会引入对引用计数的修改，导致 isKnownUniquelyReferenced(_:) 函数的结果不准确。通过将 Ref<T> 类定义为 final，可以确保引用计数的一致性，从而正确地实现 Copy-on-Write 的逻辑。
 */
/// 将实际值存于class Ref中，以便实现`reference type`
final class Ref<T> { //必须使用final修饰
    var val: T
    init(_ v: T) { val = v }
}

/// Box包装`reference type`
struct Box<T> {
    var ref: Ref<T>
    init(_ x: T) { ref = Ref(x) }

    var value: T {
        get { return ref.val }
        set {
            //在进行写操作前，检查是否有其他引用，如果有，进行复制
            if !isKnownUniquelyReferenced(&ref) {
                ref = Ref(newValue)
                return
            }
            ref.val = newValue
        }
    }
}

struct TestCOW {
    var id: Int = 0
}

let test = TestCOW()

var box1 = Box(test)
var box2 = box1

address(of: &box1.ref.val)  //0x600000201570
address(of: &box2.ref.val)  //0x600000201570

box2.value.id = 1

address(of: &box1.ref.val)  //0x600000201570
address(of: &box2.ref.val)  //0x600000201d90



