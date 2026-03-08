使用 `subscript`可以给任意类型(枚举、结构体、类)增加下标功能

* `subscript` 的语法类似于实例方法、计算属性，都是指定一个或多个输入参数和一个返回类型。本质就是方法
* 与实例方法不同的是，下标可以设定为读写或只读
* `subscript` 中定义的返回值类型决定了 `get` 方法的返回值类型和 `set` 方法中 `newValue` 的类型
* `subscript` 可以接收多个参数，并且任意类型
* `subscript` 可以没有 `set` 方法，但是必须有 `get` 方法。如果只有 `get` 方法，那么可以省略 `get`
* 下标可以设置标签参数，可以是类型方法
* 与函数一样，下标可以接受不同数量的参数，并且为这些参数提供默认值。但是，与函数不同的是，下标不能使用 `in-out` 参数。
* 一个类或结构体可以根据自身需要提供多个下标实现，使用下标时将通过入参的数量和类型进行区分，自动匹配合适的下标。它通常被称为下标的重载。

``` Swift
/*
subscript(index: Int) -> Int {
    get {
        // 返回一个适当的 Int 类型的值
    }
 
    set(newValue) {
        // 执行适当的赋值操作
    }
}
 
//如同只读计算型属性，对于只读下标的声明，可以省略 get 关键字和对应的大括号组来进行简写
subscript(index: Int) -> Int {
    // 返回一个适当的 Int 类型的值
}
*/


//类型下标
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}
let mars = Planet[4]
print(mars)
``` 