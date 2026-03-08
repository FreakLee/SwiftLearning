## 存储属性

存储在特定类或结构体实例里的一个常量或变量

* 类似于成员变量这个概念
* 存储在实例的内存中
* 结构体、类可以定义存储属性
* 枚举不可以定义存储属性

在创建类 或 结构体的实例时，必须为所有的存储属性设置一个合适的初始值
* 可以在初始化器里为存储属性设置一个初始值
* 可以分配一个默认的属性值作为属性定义的一部分

### 延时存储属性

延时加载存储属性是指当第一次被调用的时候才会计算其初始值的属性。在属性声明前使用 `lazy` 来标示一个延时加载存储属性。

* 必须将延时加载属性声明成变量（使用 `var` 关键字），因为属性的初始值可能在实例构造完成之后才会得到。而常量属性在构造过程完成之前必须要有初始值，因此无法声明成延时加载
* 如果一个被标记为 `lazy` 的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次

## 计算属性

计算属性不直接存储值，而是提供一个 `getter` 和一个可选的 `setter`，来间接获取和设置其他属性或变量的值

* 本质上就是方法
* 不占用实例的内存
* 枚举、结构体、类都可以定义计算属性
* 定义计算属性只能用 `var`，不能用 `let`
* `set` 传入的新值默认叫做 `newValue` ，也可以自定义
* 只读计算属性:只有 `get`，没有 `set`
* 枚举原始值 `rawValue` 的本质是:只读计算属性

``` Swift
struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

//简化 Setter 声明
//如果计算属性的 setter 没有定义表示新值的参数名，则可以使用默认名称 newValue
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

//简化 Getter 声明
//如果整个 getter 是单一表达式，getter 会隐式地返回这个表达式结果
struct CompactRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            Point(x: origin.x + (size.width / 2),
                  y: origin.y + (size.height / 2))
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

```

## 属性观察器

属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外。

可在以下位置添加属性观察器：
* 自定义的存储属性
* 继承的存储属性
* 继承的计算属性

可为属性添加其中一个或两个观察器：
* `willSet` 在新的值被设置之前调用
* `didSet` 在新的值被设置之后调用
* `willSet` 会传递新值，默认叫 `newValue`
* `didSet` 会传递旧值，默认叫 `oldValue`
* 在初始化器中设置属性值不会触发 `willSet`和 `didSet`
* 在属性定义时设置初始值也不会触发 `willSet`和 `didSet`
* 在父类初始化方法调用之后，在子类构造器中给父类的属性赋值时，会调用父类属性的 `willSet` 和 `didSet` 观察器。而在父类初始化方法调用之前，给子类的属性赋值时不会调用子类属性的观察器
* 如果将带有观察器的属性通过 `in-out` 方式传入函数，`willSet` 和 `didSet` 也会调用。这是因为 `in-out` 参数采用了拷入拷出内存模式：即在函数内部使用的是参数的 `copy`，函数结束后，又对参数重新赋值
* 计算属性和观察属性器所描述的功能也可以用于全局变量和局部变量

``` Swift
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("将 totalSteps 的值设置为 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
```
## 属性包装器
属性包装器在管理属性如何存储和定义属性的代码之间添加了一个分隔层。

比如，如果你的属性需要线程安全性检查或者需要在数据库中存储它们的基本数据，那么必须给每个属性添加同样的逻辑代码。当使用属性包装器时，你只需在定义属性包装器时编写一次管理代码，然后应用到多个属性上来进行复用。