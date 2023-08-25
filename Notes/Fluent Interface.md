# 流式接口（Fluent Interface）

## 引言

回到我们上篇Swift [函数式编程](https://github.com/FreakLee/SwiftLearning/blob/main/Notes/%E5%87%BD%E6%95%B0%E5%BC%8F%E7%BC%96%E7%A8%8B.md)中的那个例子：[(num + 3) * 5 - 1] % 10 / 2。现在，我们换成一个被称为[流式接口](https://zh.wikipedia.org/wiki/%E6%B5%81%E5%BC%8F%E6%8E%A5%E5%8F%A3)（Fluent Interface）的设计模式实现该功能。这种模式可以让我们按照链式的方式调用函数，并且每个函数的返回值是一个包含下一个函数的对象。


> 流式接口（fluent interface）是软件工程中面向对象API的一种实现方式，以提供更为可读的源代码。最早由Eric Evans与Martin Fowler于2005年提出。
>
>通常采取方法瀑布调用 (具体说是方法链式调用)来转发一系列对象方法调用的上下文。这个上下文（context）通常是指：
>
>* 通过被调方法的返回值定义
>* 自引用，新的上下文等于老的上下文。
>* 返回一个空的上下文来终止。
>
>C++的iostream流式调用就是一个典型的例子。Smalltalk在1970年代就实现了方法瀑布调用。

Talk is cheap. Show me the code.


## 示例一

首先，我们定义一个泛型类 Chain\<T>，用于包装值并支持链式调用。

``` Swift
struct Chain<T> {
    private let value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    func apply<U>(_ transform: (T) -> U) -> Chain<U> {
        let newValue = transform(value)
        return Chain<U>(newValue)
    }
    
    func getResult() -> T {
        return value
    }
}
```

在上述代码中，泛型类 Chain\<T> 拥有一个泛型属性 value，用于存储当前的值。接着，我们定义了 apply 方法，该方法接受一个转换闭包，并将当前的值传递给闭包进行转换。转换后的结果作为下一个函数的输入，并构建一个新的 Chain\<U> 对象来包装转换后的值。最后，我们定义了 getResult 方法，用于获取最终的结果值。

``` Swift
extension Chain where T: Numeric {
    func add(_ value: T) -> Chain<T> {
        return apply { $0 + value }
    }
    
    func multiply(_ value: T) -> Chain<T> {
        return apply { $0 * value }
    }
    
    func subtract(_ value: T) -> Chain<T> {
        return apply { $0 - value }
    }
}

// 以下两个需要加个条件处理，否则会报错：Binary operator '%' cannot be applied to two 'T' operands
extension Chain where T: Numeric, T: BinaryInteger {
    func modulo(_ value: T) -> Chain<T> {
        return apply { $0 % value }
    }
    
    func divide(_ value: T) -> Chain<T> {
        return apply { $0 / value }
    }
}

let x = 10
let result = Chain(x)
    .add(3)
    .multiply(5)
    .subtract(1)
    .modulo(10)
    .divide(2)
    .getResult()

print(result) // 输出: 2
```

在上述代码中，我们给泛型类 Chain\<T>，增加了两个扩展，并使用协议约束 T 的类型。

在扩展中，我们定义了 add、multiply、subtract、modulo 和 divide 方法，这些方法执行数值类型的相应操作，并调用 apply 方法将转换闭包应用于当前值。

最后，我们像流水一样依次调用表达式中对应的方法，得到最终的结果 2。

## 示例二

下面再举一个例子，假设我们要设计一个用于构建HTML文档的流式接口，我们可以定义一个HTMLBuilder类，它提供了一些方法来创建和操作HTML元素，并返回自身以支持方法链。例如：

``` Swift
class HTMLBuilder {
    private var htmlString = ""
    
    // 添加文档类型
    @discardableResult
    func doctype(_ type: String) -> HTMLBuilder {
        htmlString.append("<!DOCTYPE \(type)>\n")
        return self
    }
    
    // 添加HTML元素
    @discardableResult
    func html(_ closure: (HTMLBuilder) -> Void) -> HTMLBuilder {
        htmlString.append("<html>\n")
        closure(self)
        htmlString.append("</html>\n")
        return self
    }
    
    // 添加head元素
    @discardableResult
    func head(_ closure: (HTMLBuilder) -> Void) -> HTMLBuilder {
        htmlString.append("<head>\n")
        closure(self)
        htmlString.append("</head>\n")
        return self
    }
    
    // 添加title元素
    @discardableResult
    func title(_ text: String) -> HTMLBuilder {
        htmlString.append("<title>\(text)</title>\n")
        return self
    }
    
    // 添加body元素
    @discardableResult
    func body(_ closure: (HTMLBuilder) -> Void) -> HTMLBuilder {
        htmlString.append("<body>\n")
        closure(self)
        htmlString.append("</body>\n")
        return self
    }
    
    // 添加h1元素
    @discardableResult
    func h1(_ text: String) -> HTMLBuilder {
        htmlString.append("<h1>\(text)</h1>\n")
        return self
    }
    
    // 添加p元素
    @discardableResult
    func p(_ text: String) -> HTMLBuilder {
        htmlString.append("<p>\(text)</p>\n")
        return self
    }
    
    // 获取构建的HTML文档字符串
    func build() -> String {
        return htmlString
    }
}

// 创建一个HTMLBuilder对象
let builder = HTMLBuilder()

// 使用流式接口构建HTML文档
builder
  .doctype("html") 
  .html { 
    $0.head { 
      $0.title("Hello, world!")
    }
    .body { 
      $0.h1("Hello, world!") 
      .p("This is a fluent interface example.")
    }
  }

// 获取生成的HTML文档字符串
let html = builder.build()
//print(html)
```

可以看到，使用流式接口的代码非常简洁和易读，就像是在描述HTML文档的结构一样。这就是流式接口的优势所在。

## 流式接口与方法链（Method Chaining）

通过上述两个例子，我们可以直观地感受到流式接口有点方法链的意思。[方法链式调用（Method chaining）](https://zh.wikipedia.org/wiki/%E6%96%B9%E6%B3%95%E9%93%BE%E5%BC%8F%E8%B0%83%E7%94%A8)，也称为命名参数惯用法（named parameter idiom），是面向对象编程语言中多个方法被调用时的常用语法。每个方法都返回一个对象，允许在单个语句中将调用链接在一起，而无需变量来存储中间结果。

使用 ObjC 的iOS开发者，想必都用过一个叫[Masonry](https://github.com/SnapKit/Masonry)的开源库，当然它后期也有Swift版本[SnapKit](https://github.com/SnapKit/SnapKit)。从这个库里我们可以看到很多方法链式调用的例子。显然，对于最上面的例子，我们也可以使用这种方法实现。

``` Swift
class Calculator {
    private var result: Int = 0
    
    init(value: Int) {
        self.result = value
    }
    
    func calculate() -> Calculator {
        return Calculator(value: 0)
    }
    
    @discardableResult
    func add(_ number: Int) -> Calculator {
        result += number
        return self
    }
    
    @discardableResult
    func subtract(_ number: Int) -> Calculator {
        result -= number
        return self
    }
    
    @discardableResult
    func multiply(_ number: Int) -> Calculator {
        result *= number
        return self
    }
    
    @discardableResult
    func divide(_ number: Int) -> Calculator {
        if number != 0 {
            result /= number
        } else {
            print("Error: Division by zero!")
        }
        return self
    }
    
    @discardableResult
    func modulo(_ number: Int) -> Calculator {
        result %= number
        return self
    }
    
    func getResult() -> Int {
        return result
    }
}

//[(num + 3) * 5 - 1] % 10 / 2
let calculator = Calculator(value: 10)
let ret = calculator
    .add(3)
    .multiply(5)
    .subtract(1)
    .modulo(10)
    .divide(2)
    .getResult()

print(ret)  // 2
```

通过上面这些例子，我们可以看出流式接口与方法链其实非常相似，流式接口通常依赖于方法链来实现，同时它们之间有些细微的区别：

1. **连贯性**: 流式接口的主要目标是实现API的连贯性和可读性，使代码看起来更像自然语言。方法链可能不一定追求这种自然语言的连贯性，它主要关注将一系列方法调用链接在一起。

2. **返回值**: 流式接口的每个方法通常返回一个新的对象或值，这使得可以在链中的每个步骤上执行不同的操作。方法链通常返回的是原始对象，并依赖于该对象的状态来实现方法的链接。

## 结束语
通过上面这些例子，我们初步了解流式接口与方法链的简单应用，以及它们之间的细微区别。其实类似的概念还有管道化、方法级联，它们都指的是在一行代码中链式调用多个方法的能力。

1. **方法链**: 指的是在同一个对象上连续调用多个方法，无需重新将结果赋值给变量。
2. **方法级联**: 是一个类似的概念，但通常指的是能够链式调用多个方法并返回原始对象，从而实现更流畅和可读性更高的代码。
3. **流式接口**: 是一种设计模式，强调方法链和方法级联，旨在使API更具可读性和表达力。
4. **管道化**: 指的是能够将多个方法链接在一起，其中每个方法作为下一个方法的输入，类似于现实世界中的管道工作原理。

所有这些概念的目标都是通过允许开发人员在一行代码中链式调用多个方法，使代码更具可读性和表达力。