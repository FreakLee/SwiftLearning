在 `Swift` 中 `String` 类型是值类型。如果创建了一个新的字符串，那么当其进行常量、变量赋值操作，或在函数/方法中传递时，会进行值拷贝。在前述任一情况下，都会对已有字符串值创建新副本，并对该新副本而非原始字符串进行传递或赋值操作。

## 字符串字面量

``` Swift
// 字符串字面量
let someString = "Some string literal value"

// 多行字符串字面量
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
```

## 初始化空字符串

``` Swift
var emptyString = ""               // 空字符串字面量
var anotherEmptyString = String()  // 初始化方法
// 两个字符串均为空并等价。
```

## 字符

``` Swift
// 遍历字符串
for character in "Dog!🐶" {
    print(character)
}

// 字符串可以通过传递一个值类型为 Character 的数组作为自变量来初始化
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)
// 打印输出：“Cat!🐱”
```

## 字符串插值

字符串插值是一种构建新字符串的方式，可以在其中包含常量、变量、字面量和表达式

``` Swift
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message 是 "3 times 2.5 is 7.5"
```
