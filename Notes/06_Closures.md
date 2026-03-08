
一个函数和它所捕获的变量\常量环境组合起来，称为闭包

* 一般指定义在函数内部的函数
* 一般它捕获的是最外层的局部变量\常量
* 闭包和函数是引用类型

闭包的三种形式
* 全局函数是一个有名字但不会捕获任何值的闭包
* 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
* 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包

## 闭包表达式

``` Swift

//闭包表达式语法
/*
{ (parameters) -> return type in
    statements
}
*/

//数组排序算法
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)

//使用闭包表达式版本
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

//根据上下文推断类型
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

//单表达式闭包的隐式返回
//单行表达式闭包可以通过省略 return 关键字来隐式返回单行表达式的结果
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

//参数名称缩写
//Swift 自动为内联闭包提供了参数名称缩写功能，可以直接通过 $0，$1，$2 来顺序调用闭包的参数，以此类推
reversedNames = names.sorted(by: { $0 > $1 } )

//运算符方法
reversedNames = names.sorted(by: >)

//使用尾随闭包
reversedNames = names.sorted() { $0 > $1 }

//如果闭包表达式是函数或方法的唯一参数，则使用尾随闭包时，可以把 () 省略掉
reversedNames = names.sorted { $0 > $1 }
```

## 尾随闭包

如果需要将一个很长的闭包表达式作为最后一个参数传递给函数，将这个闭包替换成为尾随闭包的形式很有用。尾随闭包是一个书写在函数调用圆括号之后的闭包表达式，函数支持将其作为最后一个参数调用。在使用尾随闭包时，不用写出它的参数标签：

``` Swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函数体部分
}

// 以下是不使用尾随闭包进行函数调用
someFunctionThatTakesAClosure(closure: {
    // 闭包主体部分
})

// 以下是使用尾随闭包进行函数调用
someFunctionThatTakesAClosure() {
    // 闭包主体部分
}
```

## 逃逸闭包

当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，称该闭包从函数中逃逸。当定义接受闭包作为参数的函数时，在参数名之前标注 `@escaping`，用来指明这个闭包是允许“逃逸”出这个函数的。

一种能使闭包“逃逸”出函数的方法是，将这个闭包保存在一个函数外部定义的变量中。举个例子，很多启动异步操作的函数接受一个闭包参数作为 completion handler。这类函数会在异步操作开始之后立刻返回，但是闭包直到异步操作结束后才会被调用。在这种情况下，闭包需要“逃逸”出函数，因为闭包需要在函数返回之后被调用。例如：

``` Swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```

## 自动闭包

自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。

自动闭包让你能够延迟求值，因为直到你调用这个闭包，代码段才会被执行。

``` Swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

//customerProvider 的类型不是 String，而是 () -> String，一个没有参数且返回值为 String 的函数。
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// 打印出“5”

print("Now serving \(customerProvider())!")
// 打印出“Now serving Chris!”
print(customersInLine.count)
// 打印出“4”

//将闭包作为参数传递给函数时，你能获得同样的延时求值行为
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// 打印出“Now serving Alex!”


//通过将参数标记为 @autoclosure 来接收一个自动闭包，完成相同的操作
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
// 打印“Now serving Ewa!”
```




