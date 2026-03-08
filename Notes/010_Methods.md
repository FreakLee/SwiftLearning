枚举、结构体、类都可以定义实例方法、类型方法

* 实例方法（Instance Methods）：通过实例对象调用
* 类型方法(Type Method)：通过类型调用，用static或者class关键字定义

类型的每一个实例都有一个隐含属性叫做 `self`，`self` 完全等同于该实例本身。可在一个实例的实例方法中使用这个隐含的 `self` 属性来引用当前实例

结构体和枚举是值类型，默认情况下，值类型的属性不能被自身的实例方法修改，在 `func` 关键字前加`mutating` 可以允许这种修改行为 

在 `func` 前面加个 `@discardableResult`，可以消除函数调用后返回值未被使用的警告

``` Swift
//struct Point {
//    var x: Int
//    var y: Int
//    init() {
//        self.x = 0
//        self.y = 0
//    }
//
//    mutating func moveBy(x: Int, y: Int) -> () {
//        self.x += x
//        self.y += y
//    }
//}

//在可变方法中给 self 赋值
//可变方法能够赋给隐含属性 self 一个全新的实例。上面的例子可以用下面的方式改写
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaX, y: y + deltaY)
    }
}

var p1 = Point()
print("p1.x = \(p1.x),p1.y = \(p1.y)")
p1.moveBy(x: 3, y: 4)
print("p1.x = \(p1.x),p1.y = \(p1.y)")
p1.x = p1.x + 5
p1.y = p1.y + 5
print("p1.x = \(p1.x),p1.y = \(p1.y)")


//枚举的可变方法可以把 self 设置为同一枚举类型中不同的成员
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()
// ovenLight 现在等于 .high
ovenLight.next()
// ovenLight 现在等于 .off
```