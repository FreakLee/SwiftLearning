函数是一段完成特定任务的独立代码片段。在 `Swift` 中，每个函数都有一个由函数的参数值类型和返回值类型组成的类型。可以把函数类型当做任何其他普通变量类型一样处理，这样就可以更简单地把函数当做别的函数的参数，也可以从其他函数中返回函数。函数的定义可以写在其他函数定义中，这样可以在嵌套函数范围内实现功能封装。

## 函数的定义与调用

``` Swift
func 函数名称(参数列表) -> return type {
    函数体
}
 
//函数的文档注释

/// 问候
///
/// 向某人问候
///
/// - Parameter name: 名字，默认Jack
/// - Returns: 无返回值
///
/// -Note:传入名字即可
///
func sayHello(to name: String = "Jack") {//to 为参数标签
    print("Hello \(name)")
}
```

## 函数参数与返回值

函数参数与返回值在 `Swift` 中非常的灵活。可以定义任何类型的函数，包括从只带一个未名参数的简单函数到复杂的带有表达性参数名和不同参数选项的复杂函数

### 无参数函数

``` Swift
func sayHelloWorld() -> String {
    return "hello, world"
}
```

### 多参数函数

``` Swift
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return "alreadyGreeted"
    } else {
        return "greeted"
    }
}
```

### 无返回值函数

``` Swift
func sayHello(to name: String = "Jack") {
    print("Hello \(name)")
}

//func sayHello(to name: String) -> () {
//    print("Hello \(name)")
//}

//func sayHello(to name: String) -> Void {
//    print("Hello \(name)")
//}
```

### 多重返回值函数

用元组（`tuple`）类型让多个值作为一个复合值从函数中返回

``` Swift
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
```

### 可选元组返回类型

``` Swift
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
```

### 隐式返回的函数

函数体为单一表达式时隐式返回

``` Swift
func sum(num1: Int, num2: Int) -> Int {
    num1 + num2
}
```

## 函数参数标签和参数名称

每个函数参数都有一个参数标签（`argument label`）以及一个参数名称（`parameter name`）。参数标签在调用函数的时候使用；调用的时候需要将函数的参数标签写在对应的参数前面。参数名称在函数的实现中使用。默认情况下，函数参数使用参数名称来作为它们的参数标签。

``` Swift
func someFunction(firstParameterName: Int, secondParameterName: Int) {
    // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
}
someFunction(firstParameterName: 1, secondParameterName: 2)
```
参数名必须唯一，参数标签可以重名，但尽量也保持唯一。

### 指定参数标签

``` Swift
func someFunction(argumentLabel parameterName: Int) {
    // 在函数体内，parameterName 代表参数值
}
```

### 忽略参数标签

不希望为某个参数添加一个标签，可以使用一个下划线（`_`）来代替一个明确的参数标签
``` Swift
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
     // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
}
someFunction(1, secondParameterName: 2)
```

### 默认参数值

``` Swift
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault = 6
someFunction(parameterWithoutDefault: 4) // parameterWithDefault = 12
```

### 可变参数

* 一个 **可变参数（`variadic parameter`）** 可以接受零个或多个值
* 可变参数的传入值在函数体中变为此类型的一个数组
* 一个函数能拥有多个可变参数。可变参数后的第一个形参前必须加上实参标签

``` Swift
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
```

### 输入输出参数

函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误。这意味着你不能错误地更改参数值。如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为输入输出参数（`In-Out Parameters`）

* 输入输出参数不能有默认值，而且可变参数不能用 `inout` 标记
* 输入输出参数只能传入被多次赋值的，不能传入常量或者字面量
* 输入输出参数本质是地址传递（引用传递）

``` Swift
func swap(_ num1: inout Int, _ num2: inout Int) {
    (num1, num2) = (num2, num1)
}
```

输入输出参数被传递时遵循如下规则：

* 函数调用时，参数的值被拷贝
* 函数体内部，拷贝后的值被修改
* 函数返回后，拷贝后的值被赋值给原参数。

这种行为被称为拷入拷出（`copy-in copy-out`） 或值结果调用（`call by value result`）

## 函数类型

每个函数都有种特定的函数类型，函数的类型由函数的参数类型和返回类型组成

``` Swift
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}

//使用函数类型
var mathFunction: (Int, Int) -> Int = addTwoInts

//函数类型作为参数类型
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
// 打印“Result: 8”

func next(_ input: Int) -> Int {
    input + 1
}

func previous(_ input: Int) -> Int {
    input - 1
}

//函数类型作为返回类型，返回值是函数类型的函数，叫做高阶函数(Higher-Order Function)
func forward(_ forward: Bool) -> (Int) -> Int {
    forward ? next : previous
}
print(forward(true)(3)) // 4
print(forward(false)(3))// 2
```

## 嵌套函数

``` Swift
func forward(_ forward: Bool) -> (Int) -> Int {
    func next(_ input: Int) -> Int {
        input + 1
    }

    func previous(_ input: Int) -> Int {
        input - 1
    }

    return forward ? next : previous
}

print(forward(true)(3)) // 4
print(forward(false)(3))// 2
```

## 函数重载

* 函数名相同
* 参数不同（个数|类型|标签）
* 与函数返回值无关

## 内联函数

将函数调用展开成函数体

``` Swift
// 永远不会被内联(即使开启了编译器优化)
@inline(never) func test1() {
    print("test")
}

// 开启编译器优化后，即使代码很长，也会被内联(递归调用函数、动态派发的函数除外)
@inline(__always) func test2() {
    print("test")
}
```

在 `Release`  模式下，编译器已经开启优化，会自动决定哪些函数需要内联，因此没必要使用`@inline`
