在 `Swift` 中，枚举类型是一等（`first-class`）类型。它们采用了很多在传统上只被类（`class`）所支持的特性，例如计算属性（`computed properties`），用于提供枚举值的附加信息，实例方法（`instance methods`），用于提供和枚举值相关联的功能。枚举也可以定义构造函数（`initializers`）来提供一个初始值；可以在原始实现的基础上扩展它们的功能；还可以遵循协议（`protocols`）来提供标准的功能。

## 枚举语法

``` Swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}
//与 C 和 Objective-C 不同，Swift 的枚举成员在被创建时不会被赋予一个默认的整型值。在上面的 CompassPoint 例子中，north，south，east 和 west 不会被隐式地赋值为 0，1，2 和 3。相反，这些枚举成员本身就是完备的值，这些值的类型是已经明确定义好的 CompassPoint 类型。


//多个成员值可以出现在同一行上，用逗号隔开
enum Direction: String, CaseIterable {
    case north, south, east, west
}
```

## 使用 Switch 语句匹配枚举值

``` Swift
//使用 Switch 语句匹配枚举值
var directionToHead = CompassPoint.west
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
// 打印“Watch out for penguins”
```

## 枚举成员的遍历

枚举成员的遍历，需要令枚举遵循 `CaseIterable` 协议

``` Swift
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count

for beverage in Beverage.allCases {
    print(beverage)
}
```

## 关联值

把其他类型的值和成员值一起存储起来会很有用。这额外的信息称为关联值，并且你每次在代码中使用该枚举成员时，还可以修改这个关联值。

可以定义 `Swift` 枚举来存储任意类型的关联值，如果需要的话，每个枚举成员的关联值类型可以各不相同。枚举的这种特性跟其他语言中的可识别联合（`discriminated unions`），标签联合（`tagged unions`），或者变体（`variants`）相似。

``` Swift
enum Barcode {
	case upc(Int, Int, Int, Int)
	case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

定义一个名为 `Barcode` 的枚举类型，它的一个成员值是具有 (Int，Int，Int，Int) 类型关联值的 `upc`，另一个成员值是具有 `String` 类型关联值的 `qrCode` 。

## 原始值

枚举成员使用相同类型的默认值预先对应，这个默认值叫原始值

* 原始值可以是字符串、字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的
* 原始值不占用枚举变量的内存
* 原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值,对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化

``` Swift
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

let earthsOrder = Planet.earth.rawValue //3

//使用原始值初始化枚举
let possiblePlanet = Planet(rawValue: 7)
// possiblePlanet 类型为 Planet? 值为 Planet.uranus
```

## 递归枚举

递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。使用递归枚举时，编译器会插入一个间接层。可以在枚举成员前加上 `indirect` 来表示该成员可递归。

``` Swift
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

也可以在枚举类型开头加上 indirect 关键字来表明它的所有成员都是可递归的

``` Swift
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

//递归枚举创建表达式 (5 + 4) * 2
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

//递归函数求值
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(product)) //18
```