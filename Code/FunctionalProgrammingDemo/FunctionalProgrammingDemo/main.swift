//
//  main.swift
//  FunctionalProgrammingDemo
//
//  Created by min Lee  on 2023/8/20.
//  Copyright © 2023年 min Lee. All rights reserved.
//

import Foundation

//MARK: 常用的高阶函数

// map 函数
let numbers = [1,2,3,4,5]

func double(nums: [Int]) ->[Int] {
    var arr = [Int]()
    for num in nums {
        arr.append(num * 2)
    }
    
    return arr
}

let douNums = double(nums: numbers)
// [2, 4, 6, 8, 10]
//print(douNums)

let doubleNumbers = numbers.map { $0 * 2 }
// [2, 4, 6, 8, 10]
//print(doubleNumbers)

//flatMap函数
let array = ["Hello", "World"]

let flattenedArray = array.flatMap { $0.map { String($0) } }
// ["H", "e", "l", "l", "o", "W", "o", "r", "l", "d"]
// print(flattenedArray)

let mapedArray = array.map { $0.map { String($0) } }
// [["H", "e", "l", "l", "o"], ["W", "o", "r", "l", "d"]]
//print(mapedArray)

//Optional的map和flatMap
let transformedNumbers0 = numbers.map { number -> String? in
    if number < 5 {
        return nil
    } else {
        return String(number)
    }
}

// [nil, nil, nil, nil, Optional("5")]
//print(transformedNumbers0)

/*
 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
 */
//let transformedNumbers1 = numbers.flatMap { number -> String? in
//    if number < 5 {
//        return nil
//    } else {
//        return String(number)
//    }
//}

// ["5"]
//print(transformedNumbers1)

let transformedNumbers2 = numbers.compactMap { number -> String? in
    if number < 5 {
        return nil
    } else {
        return String(number)
    }
}

// ["5"]
//print(transformedNumbers2)

let arr = ["Tom","123","Hello","-10"]
let arr1 = arr.map { Int($0) }
// [nil, Optional(123), nil, Optional(-10)]
//print(arr1)

//let arr2 = arr.flatMap { Int($0) }
// [123, -10]
//print(arr2)

let arr3 = arr.compactMap { Int($0) }
// [123, -10]
//print(arr3)

let fmt = DateFormatter()
fmt.dateFormat = "yyyy-MM-dd"

let str: String? = "2023-08-20"
// 旧写法
let date1 = str != nil ? fmt.date(from: str!) : nil
// 新写法
let date2 = str.flatMap(fmt.date)
//Optional(2023-08-19 16:00:00 +0000) Optional(2023-08-19 16:00:00 +0000)
//print(date1,date2)


// filter 函数
let evenNumbers = numbers.filter { $0 % 2 == 0 }
// [2, 4]
//print(evenNumbers)

// reduce 函数
let sum = numbers.reduce(0) { $0 + $1 }
// 15
//print(sum)

// reduce 实现 map功能
let doubledNumbers = numbers.reduce([]) { result, element in
    result + [element * 2]
}//numbers.reduce([]) { $0 + [$1 * 2] }
// [2, 4, 6, 8, 10]
//print(doubledNumbers)

// reduce 实现 filter功能
let evenNums = numbers.reduce([]) { result, element in
    if element % 2 == 0 {
        return result + [element]
    } else {
        return result
    }
}//numbers.reduce([]) { $1 % 2 == 0 ? $0 + [$1] : $0 }
// [2, 4]
//print(evenNums)

// 使用 reduce 计算最大值
let maxNum = numbers.reduce(numbers[0]) { $1 > $0 ? $1 : $0 }//{ max, element in  element > max ? element : max }
// 5
//print(maxNum)

// 使用 reduce 进行字符串拼接
let words = ["Hello", " ", "World", "!"]
let sentence = words.reduce("") { $0 + $1 }//{ result, word in return result + word }
// "Hello World!"
//print(sentence)


// allSatisfy 函数
let allPositive = numbers.allSatisfy { $0 > 0 }//{ number in return number > 0 }
// 结果为 true
//print(allPositive)

// MARK: 纯函数
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

let result = add(3, 4)  // 结果为 7


// 非纯函数
var total = 0

func addToTotal(_ value: Int) {
    total += value
}

addToTotal(5)
//print(total)  // 输出: 5

addToTotal(3)
//print(total)  // 输出: 8

// 引用透明性示例
struct Product {
    let name: String
    let price: Double
}

func calculateTotalPrice(products: [Product]) -> Double {
    return products.reduce(0.0) { $0 + $1.price }
}

let cart = [Product(name: "iPhone", price: 999.0),
            Product(name: "MacBook", price: 1999.0),
            Product(name: "AirPods", price: 199.0)]

let totalPrice = calculateTotalPrice(products: cart)
//print(totalPrice) // 输出：3197.0

let testCart = [Product(name: "Shoes", price: 99.0),
                Product(name: "T-Shirt", price: 29.0)]

let totalPrice1 = calculateTotalPrice(products: testCart)
assert(totalPrice1 == 128.0, "Incorrect total price")


//不可变数据
//假设我们有一个包含学生信息的数组，每个学生有姓名和年龄两个属性。我们想要筛选出年龄大于等于 18 岁的学生并进行打印。
struct Student {
    let name: String
    let age: Int
}

let students = [
    Student(name: "Alice", age: 20),
    Student(name: "Bob", age: 17),
    Student(name: "Charlie", age: 19),
    Student(name: "David", age: 22)
]

let adults = students.filter { $0.age >= 18 }
//adults.forEach { print($0.name) }


//MARK: 柯里化

//将两个整数相加的函数进行柯里化
//普通形式
//func add(_ a: Int, _ b: Int) -> Int {
//    return a + b
//}
//let num0 = add(3, 5); // 8

//柯里化形式
func add(_ x: Int) -> (Int) -> Int {
    return { y in
        return y + x
    }
}

let add3 = add(3)  // 创建一个新函数，将 3 添加到参数上
let num1 = add3(5) // 调用新函数，将 5 添加到参数上，得到结果 8

let num = add(3)(5) // 8


//2. 使用柯里化创建自定义的过滤函数
func filter(with condition: @escaping (Int) -> Bool) -> ([Int]) -> [Int] {
    return { numbers in
        return numbers.filter(condition)
    }
}

let evenFilter = filter { $0 % 2 == 0 } // 创建一个新函数，用于过滤偶数
let filteredNumbers = evenFilter(numbers) // 调用新函数，过滤出偶数 [2, 4]
//print(filteredNumbers)


//3.创建一个通用型的柯里化函数
func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in function(a, b) } }
}

//将上面的 add 函数柯里化
let curriedAdd = curry(add(_:_:))

let addFive = curriedAdd(5)
let addThree = addFive(3) // 相当于调用 add(5, 3)
//print(addThree) // 输出结果 8


//4.反柯里化
func uncurriedAdd(_ a: Int, _ b: Int) -> Int {
    return a + b
}

let addFn = uncurriedAdd
var tempNum = addFn(3,5)
//print(tempNum) // 8


//5.部分应用
func multiply(_ a: Int, _ b: Int, _ c: Int) -> Int {
    return a * b * c
}

let multiplyByTwo: (Int, Int) -> Int = { multiply(2, $0, $1) }
tempNum = multiplyByTwo(3,4) //相当于调用 multiply(2, 3, 4)
//print(tempNum) //4


//MARK: 函数合成

//假设我们有以下两个简单的函数：
func addOne(_ x: Int) -> Int {
    return x + 1
}

func double(_ x: Int) -> Int {
    return x * 2
}

//定义一个高阶函数 compose，它接收两个函数作为输入，并返回一个新的函数，该函数将输入值应用于第一个函数，然后将结果应用于第二个函数
//func compose<A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
//    return { x in
//        f(g(x))
//    }
//}

//多个函数合成 替换上面方法，方便后面演示函数合成的结合律
func compose<T>(_ functions: ((T) -> T)...) -> (T) -> T {
    return { x in
        var result = x
        for function in functions.reversed() {
            result = function(result)
        }
        return result
    }
}

//使用 compose 函数将 addOne 和 double 函数进行合成，创建一个新的函数
let composedFunction = compose(double, addOne)

//composedFunction 是一个合成函数，它将输入值应用于 addOne 函数，然后将结果应用于 double 函数

//调用合成函数composedFunction
tempNum = composedFunction(3)
//print(tempNum)  // 输出：8


//函数合成的结合律
func subtractThree(_ x: Int) -> Int {
    return x - 3
}

//不满足结合律
let result1 = subtractThree(double(addOne(5)))
let result2 = subtractThree(addOne(double(5)))

//print(result1)  // 输出：9
//print(result2)  // 输出：8


//A——f(x)——>B——g(x)——>C——h(x)——>D
/*
compose(f, compose(g, h))
// 等同于
compose(compose(f, g), h)
// 等同于
compose(f, g, h)
*/

//满足结合律
let composedFunction1 = compose(subtractThree, compose(double, addOne))
let composedFunction2 = compose(compose(subtractThree, double), addOne)
let composedFunction3 = compose(subtractThree, double, addOne)

let result3 = composedFunction1(5)
let result4 = composedFunction2(5)
let result5 = composedFunction3(5)

//print(result3)  // 输出：9
//print(result4)  // 输出：9
//print(result5)  // 输出：9


//单位元
func identity<T>(_ value: T) -> T {
    return value
}

let add1 = { (x: Int) -> Int in
    return x + 1
}

let multiplyBy2 = { (x: Int) -> Int in
    return x * 2
}

//以下五句等价
let composed = compose(identity, add1, multiplyBy2, identity)
//let composed = compose(add1, multiplyBy2, identity)
//let composed = compose(identity, add1, multiplyBy2)
//let composed = compose(add1, multiplyBy2)
//let composed = compose(identity, add1, identity, multiplyBy2, identity)

tempNum = composed(3)  // 结果为 7
//print(tempNum)


//可逆性：是指能够通过一个函数合成操作，将两个函数互相取消或逆转的特性。当两个函数可以通过函数合成相互抵消，恢复到原始状态，我们称它们具有可逆性
struct UserProfile {
    var name: String
    var age: Int
    var email: String
}

func setName(_ newName: String) -> (UserProfile) -> UserProfile {
    return { user in
        var updatedUser = user
        updatedUser.name = newName
        return updatedUser
    }
}

func setAge(_ newAge: Int) -> (UserProfile) -> UserProfile {
    return { user in
        var updatedUser = user
        updatedUser.age = newAge
        return updatedUser
    }
}

func setEmail(_ newEmail: String) -> (UserProfile) -> UserProfile {
    return { user in
        var updatedUser = user
        updatedUser.email = newEmail
        return updatedUser
    }
}

let updateProfile = compose(setName("David"), setAge(35), setEmail("david@example.com"))

var user = UserProfile(name: "John", age: 30, email: "john@example.com")
user = updateProfile(user)
//print(user) //UserProfile(name: "David", age: 35, email: "david@example.com")

let resetProfile = compose(setName("John"), setAge(30), setEmail("john@example.com"))
user = resetProfile(user)
//print(user) //UserProfile(name: "John", age: 30, email: "john@example.com")


//MARK: 简单示例

//假定我们要实现如下功能：[(num + 3) * 5 - 1] % 10 / 2

//这里为了不与上下文的函数冲突，用do语句弄个作用域
do {
    // 加法函数
    func add(_ v1: Int, _ v2: Int) -> Int {
        return v1 + v2
    }

    // 减法函数
    func subtract(_ v1: Int, _ v2: Int) -> Int {
        return v1 - v2
    }

    // 乘法函数
    func multiply(_ v1: Int, _ v2: Int) -> Int {
        return v1 * v2
    }

    // 除法函数
    func divide(_ v1: Int, _ v2: Int) -> Int {
        return v1 / v2
    }

    // 取模函数
    func modulo(_ v1: Int, _ v2: Int) -> Int {
        return v1 % v2
    }

    // [(num + 3) * 5 - 1] % 10 / 2
    let num = 10
    let result = divide(modulo(subtract(multiply(add(num, 3), 5), 1), 10), 2)

    print(result) // 2
}


//将上面五个函数柯里化
//do {
//    // 加法函数
//    func add(_ v1: Int) -> (Int) -> Int {
//        return { v2 in v2 + v1 }
//    }
//}

// 减法函数
func subtract(_ v1: Int) -> (Int) -> Int {
    return { v2 in v2 - v1 }
}

// 乘法函数
func multiply(_ v1: Int) -> (Int) -> Int {
    return { v2 in v2 * v1 }
}

// 除法函数
func divide(_ v1: Int) -> (Int) -> Int {
    return { v2 in v2 / v1 }
}

// 取模函数
func modulo(_ v1: Int) -> (Int) -> Int {
    return { v2 in v2 % v1 }
}


//使用自定义运算符 >>> 将五个函数合成为一个通用函数
precedencegroup FunctionComposition { //结合性
    associativity: left
}

infix operator >>>: FunctionComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { x in
        g(f(x))
    }
}

// [(num + 3) * 5 - 1] % 10 / 2
let calculate = add(3) >>> multiply(5) >>> subtract(1) >>> modulo(10) >>> divide(2)
let number = 10
let ret = calculate(number)
print(ret) //2


//MARK: 应用函数式编程思想处理实际的业务逻辑示例
//假设我们有一个餐厅的订单数据，每个订单包含菜品的名称、数量和价格。我们想要计算每个订单的总金额，并筛选出总金额大于某个阈值的订单
struct Order {
    let itemName: String
    let quantity: Int
    let price: Double
}

let orders = [
    Order(itemName: "Pizza", quantity: 2, price: 12.99),
    Order(itemName: "Burger", quantity: 1, price: 8.99),
    Order(itemName: "Salad", quantity: 3, price: 6.99),
    Order(itemName: "Pasta", quantity: 2, price: 10.99)
]

let threshold = 20.0

// 计算每个订单的总金额
let totalAmounts = orders.map { order in
    order.price * Double(order.quantity)
}

// 筛选出总金额大于阈值的订单
let filteredOrders = zip(orders, totalAmounts)
    .filter { $0.1 > threshold }
    .map { $0.0 }

// 打印筛选后的订单
filteredOrders.forEach { order in
    print("Item: \(order.itemName), Quantity: \(order.quantity), Price: \(order.price)")
}

