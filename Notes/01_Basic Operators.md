## 赋值运算符

赋值运算符（a = b），表示用 b 的值来初始化或更新 a 的值

``` Swift
let b = 10
var a = 5
a = b
// a 现在等于 10
```

与 `C` 语言和 `Objective-C` 不同，`Swift` 的赋值操作并不返回任何值，支持组合赋值运算

## 算术运算符

* 加法（+）
* 减法（-）
* 乘法（*）
* 除法（/）
* 取余（%）

## 比较运算符

* 等于（a == b）
* 不等于（a != b）
* 大于（a > b）
* 小于（a < b）
* 大于等于（a >= b）
* 小于等于（a <= b）

如果两个元组的元素相同，且长度相同的话，元组就可以被比较。比较元组大小会按照从左到右、逐值比较的方式，直到发现有两个值不等时停止。如果所有的值都相等，那么这一对元组我们就称它们是相等的

``` Swift
(1, "zebra") < (2, "apple")   // true，因为 1 小于 2
(3, "apple") < (3, "bird")    // true，因为 3 等于 3，但是 apple 小于 bird
(4, "dog") == (4, "dog")      // true，因为 4 等于 4，dog 等于 dog
(4, "dog") > (4, "Dog")      // true，因为 4 等于 4，"d" 的ASCII（100） 大于 "D" 的ASCII（68）

// Int和String 类型可以进行比较
("blue", -1) < ("purple", 1)       // 正常，比较的结果为 true
//Binary operator '<' cannot be applied to two '(String, Bool)' operands
//("blue", false) < ("purple", true) // 错误，因为 < 不能比较布尔类型

```

`Swift` 标准库只能比较七个以内元素的元组比较函数

## 三元运算符

问题 ? 答案 1 : 答案 2

## 空合并运算符

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

## 区间运算符

* 闭区间运算符：（a...b）定义一个包含从 a 到 b（包括 a 和 b）的所有值的区间
* 半开区间运算符：（a..<b）定义一个从 a 到 b 但不包括 b 的区间
* 单侧区间：闭区间操作符有另一个表达形式，可以表达往一侧无限延伸的区间 

``` Swift
// 闭区间
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20
// 5 * 5 = 25

// 半开区间
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("第 \(i + 1) 个人叫 \(names[i])")
}
// 第 1 个人叫 Anna
// 第 2 个人叫 Alex
// 第 3 个人叫 Brian
// 第 4 个人叫 Jack


// 单侧区间
for name in names[2...] {
    print(name)
}
// Brian
// Jack

for name in names[...2] {
    print(name)
}
// Anna
// Alex
// Brian


// 半开区间操作符也有单侧表达形式，附带上它的最终值
for name in names[..<2] {
    print(name)
}
// Anna
// Alex


// 单侧区间不止可以在下标里使用，也可以在别的情境下使用
let range = ...5
range.contains(7)   // false
range.contains(4)   // true
range.contains(-1)  // true

//字符、字符串也支持区间运算符，默认不能用在for-in中
let strRange = "bb"..."ee"
print(strRange.contains("ff"))
print(strRange.contains("bz"))
print(strRange.contains("cc"))
```

## 逻辑运算符

* 逻辑非（!a）
* 逻辑与（a && b）
* 逻辑或（a || b）


