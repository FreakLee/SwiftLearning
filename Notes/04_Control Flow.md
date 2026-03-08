## For-In 循环

使用 `for-in` 循环来遍历一个集合中的所有元素，例如数组中的元素、范围内的数字或者字符串中的字符

``` Swift
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}

for name in names[0...2] {
    print(name)
}

for name in names[2...] {
    print(name)
}

//index 是一个每次循环遍历开始时被自动赋值的常量。这种情况下，index 在使用前不需要声明，只需要将它包含在循环的声明中，就可以对其进行隐式声明，而无需使用 let 关键字声明。
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

//使用下划线（_）替代变量名来忽略这个值
for _ in 1 ... 2 {
    print("for")
}

//闭区间
for i in 1 ... 4 {
    print(i)
}

//半开区间
for i in 1 ..< 4 {
    print(i)
}

//带间隔的区间值 打印3到12间的奇数
for odd in stride(from: 3, to: 12, by: 2) {
    print(odd)
}
```

## While 循环

`Swift` 提供两种 `while` 循环形式：

* `while` 循环，每次在循环开始时计算条件是否符合
* `repeat-while` 循环，每次在循环结束时计算条件是否符合，类似于 `do-while`。它和 `while` 的区别是在判断循环条件之前，先执行一次循环的代码块。然后重复循环直到条件为 `false`

``` Swift
var a = 4
while a > 0 {
    print(a)
    a -= 1
}

var num = 4
repeat {
    print(num)
    num -= 1
} while num >= 1
```

## 条件语句

`if` 语句：
* `if` 后面的条件必须是 `bool` 类型
* `if` 后面的条件小括号可以省略，但是条件后面的大括号不可以省略

``` Swift
let age = 18
if age >= 18 {  //if age会报错
    print("成年人")
} else {
    print("未成年人")
}

```

`switch` 语句：
* `switch` 必须能保证处理所有情况
* `case`、`default` 后面不能写大括号
* 默认可以不写 `break`，不会贯穿
* `case`、`default` 里面至少需要一条语句，什么都不处理可以加一句 `break`
* 加 `fallthrough` 可实现贯穿效果
* `switch` 支持字符、字符串

``` Swift
let number = 1
switch number {
case 1:
    print("1")
    fallthrough
case 2:
    print("2")
default:
    break
}

let letter = "A"
switch letter {
case "a","A": //复合case语句
    print("a or A")
default:
    break
}

//区间匹配
let count = 10
switch count {
case 0:
    print("0")
case 1...99:
    print("两位数")
default:
    break
}

//元组匹配
let pt = (1,-1)
switch pt {
case (0,0):
    print("原点")
case (0,_):
    print("y轴")
case (_,0):
    print("x轴")
case (-2...2,-2...2):
    print("在2,2内")
default :
    print("其它点")
}

//值绑定
switch pt {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}

//where语句
switch pt {
case let (x, y) where x == y:
    print("在直线x = y上")
case let (x, y) where x == -y:
    print("在直线x = -y上")
case let (x, y):
    print("点\(x),\(y)")
}

let nums = [-4,-3,-2,-1,0,1,2,3,4]
var sum = 0
for num in nums where num > 0 {
    sum += num
}
print(sum)
```

## 控制转移语句

* `continue`：告诉一个循环体立刻停止本次循环，重新开始下次循环
* `break`：立刻结束整个控制流的执行
* `fallthrough`：在 `switch` 语句中如确实需要 `C` 风格的贯穿特性，可在每个需要该特性的 `case` 分支中使用 `fallthrough` 关键字
* `return`
* `throw`

``` Swift
//continue：告诉一个循环体立刻停止本次循环，重新开始下次循环
let puzzleInput = "great minds think alike"
var puzzleOutput = ""
for character in puzzleInput {
    switch character {
    case "a", "e", "i", "o", "u", " ":
        continue
    default:
        puzzleOutput.append(character)
    }
}
print(puzzleOutput)
// 输出“grtmndsthnklk”

//带标签的语句
outer: for i in 1...4 {
    for k in 1...4 {
        
        if k == 3 {
            continue outer
        }
        
        if i == 3 {
            break outer
        }
        print("i == \(i), k == \(k)")
    }
}
```

## 提前退出

使用 `guard` 语句来要求条件必须为真时，以执行 `guard` 语句后的代码。不同于 `if` 语句，一个 `guard` 语句总是有一个 `else` 从句，如果条件不为真则执行 `else` 从句中的代码

``` Swift
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }

    print("Hello \(name)!")

    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }

    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
// 输出“Hello John!”
// 输出“I hope the weather is nice near you.”
greet(person: ["name": "Jane", "location": "Cupertino"])
// 输出“Hello Jane!”
// 输出“I hope the weather is nice in Cupertino.”
```