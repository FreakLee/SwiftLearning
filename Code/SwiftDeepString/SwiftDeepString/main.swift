//
//  main.swift
//  SwiftDeepString
//
//  Created by min Lee  on 2019/8/13.
//  Copyright © 2019 min Lee. All rights reserved.
//

import Foundation

print("-------1----------")
var str1 = "01"
print(Mems.memStr(ofVal: &str1))


print("-------2----------")
var str2 = "0123456789ABCDEF"
print(Mems.memStr(ofVal: &str2))


print("-------3----------")
var largeString = String(repeating: "0", count: 4096*4096)
print(Mems.memStr(ofVal: &largeString))


print("-------4----------")
var complexString = "你好，世界！🌍😊"//"Hello, Swift! 🌍😊 你好，世界！"
print(Mems.memStr(ofVal: &complexString))


