//
//  main.swift
//  FluentInterface
//
//  Created by min Lee  on 2023/8/24.
//  Copyright © 2023年 min Lee. All rights reserved.
//

import Foundation

//[(num + 3) * 5 - 1] % 10 / 2

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


// MARK: 流式接口示例二 HTML生成器

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


// MARK: 方法链示例
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
