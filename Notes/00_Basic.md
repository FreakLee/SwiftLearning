`Swift`是2014年WWDC正式发布的，是一门安全、高效、现代化的高级编程语言。

## Hello World

不用编写`main`函数，将全局首句可执行的代码作为程序的入口。不用在每条语句的末尾写上分号（;），多条语句写在同一行需要用分号分割。

``` Swift
print("Hello World")
```

## Playground

`Playground` 支持 `UI`

``` Swift 
import UIKit
import PlaygroundSupport

let view = UIView()
view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
view.backgroundColor = UIColor.red
//可设置为View或者VC
PlaygroundPage.current.liveView = view
```

## 常量和变量

* 使用`let`定义常量
* 使用`var`定义变量
* 常量和变量在使用之前都必须初始化

``` Swift
//定义常量
let PI:Double = 3.1415926

//Found an unexpected second identifier in constant declaration; is there an accidental break?
//let con
//con = 5

//定义变量
var age = 10
var x = 0.0, y = 0.0, z = 0.0
//都为Double类型
var red, green, blue: Double
//前俩是Int类型
var red1, green1:Int, blue1: Double

//常量和变量在使用前必须初始化
//Variable 'red' used before being initialized
//print(red)
```

## 注释

`Swift` 中的注释与 `C` 语言的注释非常相似。
* 单行注释`//`
* 多行注释，起始标记为（`/*`），终止标记为（`*/`）
* `Swift` 的多行注释可以嵌套在其它的多行注释之中
* `Playground`中的注释支持`Markup`语法（Editor->Show Render Markup）

``` Swift
// 这是一个注释

/* 这也是一个注释，
但是是多行的 */

/* 这是第一个多行注释的开头
/* 这是第二个被嵌套的多行注释 */
这是第一个多行注释的结尾 */
```

## 标识符

`Swift`中的标识符几乎可以使用任意字符，不能以数字开头，不能包含空白字符、制表符、箭头等特殊字符。

``` Swift
var 🥛 = "milk"
func 🐂() {
    print(🐂)
}
🐂()
```

如果要使用`Swift`中的关键字，可以使用\``包裹着

``` Swift
let `let` = "let"
```

## 整数

* 类型：`Int8`、`Int16`、`Int32`、`Int64`、`UInt8`、`UInt16`、`UInt32`、`UInt64`
* 范围：使用`min` 和 `max` 属性来获取对应类型的最小值和最大值
* 在32位平台，`Int`等价于`Int32`；在64位平台，`Int`等价于`Int64`
* 一般不用指定长度，直接使用`Int`
* 尽量不要使用`UInt`。统一使用 `Int` 可以提高代码的可复用性，避免不同类型数字之间的转换，并且匹配数字的类型推断

``` Swift
let decimalInteger = 17
let binaryInteger = 0b10001
let octalInteger = 0o21
let hexadecimalInteger = 0x11
let int8Max = Int8.max
```

## 浮点数

* `Double` 表示32位浮点数，精度至少15位
* `Float` 表示32位浮点数，精度6位

``` Swift
let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0 //16进制表示10进制里面的12.1875
let doubleDecimal1 = 1.25e2    //相当于 1.25 x 102, or 125.0.
let doubleDecimal2 = 1.25e-2   //相当于 1.25 x 10-2, or 0.0125.
let doubleHexDecimal1 = 0xFp2  //相当于 15 x 22, or 60.0.
let doubleHexDecimal2 = 0xFp-2 //相当于 15 x 2-2, or 3.75.
```

## 类型安全与类型推断

``` Swift
let meaningOfLife = 42
// meaningOfLife 会被推测为 Int 类型

let pi = 3.14159
// pi 会被推测为 Double 类型

let anotherPi = 3 + 0.14159
// anotherPi 会被推测为 Double 类型
```

## 数值型类型转换

``` Swift
//整型间转换
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)

//整型、浮点型间转换
let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi = Double(three) + pointOneFourOneFiveNine

/*
下面这种方式会报错
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = UInt8(twoThousand) + one
*/
```