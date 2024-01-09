## 什么是Copy-on-Write

> 写入时复制（英语：`Copy-on-write`，简称`COW`）是一种计算机程序设计领域的优化策略。其核心思想是，如果有多个调用者（callers）同时请求相同资源（如内存或磁盘上的数据存储），他们会共同获取相同的指针指向相同的资源，直到某个调用者试图修改资源的内容时，系统才会真正复制一份专用副本（private copy）给该调用者，而其他调用者所见到的最初的资源仍然保持不变。这过程对其他的调用者都是透明的。此作法主要的优点是如果调用者没有修改该资源，就不会有副本（private copy）被建立，因此多个调用者只是读取操作时可以共享同一份资源。

在 Swift 中，Copy-on-Write（写时复制）是一种优化技术，用于在需要进行修改时避免不必要的数据复制。它主要用于值类型（value types），如结构体（struct）和枚举（enum）。

在 Swift 中，当将一个值类型赋值给另一个变量或常量时，通常会发生值的复制。这意味着原始值的一个副本会被创建，并分配给新的变量或常量。这样，原始值和副本是完全独立的，对其中一个进行修改不会影响另一个。

然而，有时候进行这种复制操作是不必要的，特别是当值类型的实例是不可变的（immutable）或者只有一个引用时。为了避免不必要的复制开销，Swift 使用了 Copy-on-Write 机制。

Copy-on-Write 的基本思想是，当一个不可变的值类型实例被复制时，实际上只会增加一个指向原始数据的引用计数。只有在进行修改操作时，才会对值进行复制，以确保修改操作不会影响到其他引用。

具体来说，当一个不可变的值类型实例被赋值给一个新的变量或常量时，原始值的引用计数会增加。这样，原始值和新的变量或常量共享同一个内存。当进行第一次修改操作时，Copy-on-Write 机制会检查原始值的引用计数。如果引用计数为 1，表示该值没有被共享，可以直接进行修改。但如果引用计数大于 1，表示该值被多个引用共享，此时会进行复制操作，创建一个新的副本，并将修改操作应用在副本上，而不是原始值上。

通过使用 Copy-on-Write 机制，Swift 可以避免不必要的复制开销，提高性能和内存效率。这种优化技术在 Swift 的标准库中被广泛应用，特别是在`Array`、`Dictionary`、`Set`这样的集合类型中。

需要注意的是，Copy-on-Write 仅适用于值类型（value types），对于引用类型（reference types）如类（class），它不会自动应用。对于引用类型，需要手动实现类似的行为，例如使用复制构造函数（copy constructor）或提供自定义的复制方法。

下面，看看 Swift 中 `COW` 的具体体现。

### 基本数据类型

从下面的打印信息中我们可以看到，对于`String`、`Int`等基本类型的数据进行赋值时就发生了拷贝操作。
``` Swift
/// 打印地址
func address(of object: UnsafeRawPointer) {
    let addr = Int(bitPattern: object)
    print(String(format: "%p", addr))
}

var str1 = "1234"
var str2 = str1
address(of: &str1)  //0x100008108
address(of: &str2)  //0x100008118

var num1 = 5
var num2 = num1
address(of: &num1)  //0x100008128
address(of: &num2)  //0x100008130
```

### 集合类型

对于集合类型，如下面的arr1和arr2，我们可以看到在对写入操作前，赋值操作并未发生拷贝操作；在对arr2进行修改（即写入）后，arr2的地址发生变化，也就是说此时发生了拷贝操作。

``` Swift
var arr1 = [1,2,3,4]
var arr2 = arr1

//修改前，arr1和arr2地址一样
address(of: &arr1)   //0x600001708420
address(of: &arr2)   //0x600001708420

//对arr2进行修改
arr2[2] = 0

//修改arr2后，arr2地址变了
address(of: &arr1)   //0x600001708420
address(of: &arr2)   //0x600001708460
```

### 自定义的结构体

我们知道 Swift 中的 COW适用于值类型数据，而且通常是集合类型的。那么对于自定义的结构体是否默认也存在这种机制呢？

``` Swift
struct MyStruct {
    var data: [Int]
}

var obj1 = MyStruct(data: [1, 2, 3])
var obj2 = obj1

address(of: &obj1)  //0x100008148
address(of: &obj2)  //0x100008150

obj2.data[0] = 100

address(of: &obj1)  //0x100008148
address(of: &obj2)  //0x100008150
```
从上面的打印可以看出，对于自定义的结构体，并不支持COW。

## COW的实现

在 Swift 的GitHub官方文档[OptimizationTips.rst](https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#advice-use-copy-on-write-semantics-for-large-values)中有这样一段代码：

``` Swift
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
```
需要注意的是class Ref\<T>必须使用`final`修饰，有以下几个原因：

* **避免类的继承**：将 Ref\<T> 类定义为 final 可以防止其他类继承它。由于 Ref\<T> 类是用于支持 Box<T> 结构体的内部实现，而不是作为可继承的基类，因此将其定义为 `final` 可以确保它不会被错误地继承和扩展。
* **保持引用计数的一致性**：Ref\<T> 类使用 isKnownUniquelyReferenced(\_:) 函数来检查引用计数，以确定是否需要进行复制。如果 Ref\<T> 类是可继承的，其他子类可能会引入对引用计数的修改，导致 isKnownUniquelyReferenced(_:) 函数的结果不准确。通过将 Ref\<T> 类定义为 `final`，可以确保引用计数的一致性，从而正确地实现 Copy-on-Write 的逻辑。

## 参考

维基百科中的[写入时复制](https://zh.wikipedia.org/wiki/%E5%AF%AB%E5%85%A5%E6%99%82%E8%A4%87%E8%A3%BD)

[Use copy-on-write semantics for large values](https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#advice-use-copy-on-write-semantics-for-large-values)

[Understanding Swift Copy-on-Write mechanisms](https://medium.com/@lucianoalmeida1/understanding-swift-copy-on-write-mechanisms-52ac31d68f2f)

