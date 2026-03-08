## 数组

数组使用有序列表存储同一类型的多个值。相同的值可以多次出现在一个数组的不同位置中

``` Swift
//空数组
var someInts: [Int] = []

//创建一个带有默认值的数组
var threeDoubles = Array(repeating: 0.0, count: 3)

//通过两个数组相加创建一个数组
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles

//数组字面量
var shoppingList = ["Eggs", "Milk"]

//访问和修改数组
print("The shopping list contains \(shoppingList.count) items.")

if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list is not empty.")
}

shoppingList.append("Flour")

shoppingList += ["Baking Powder"]

var firstItem = shoppingList[0]

// 数组的遍历
for item in shoppingList {
    print(item)
}
```

## 字典

字典是一种无序的集合，它存储的是键值对之间的关系，其所有键的值需要是相同的类型，所有值的类型也需要相同。每个值（value）都关联唯一的键（key），键作为字典中这个值数据的标识符

``` Swift
//创建一个空字典
var namesOfIntegers: [Int: String] = [:]

//字典字面量
var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

//访问和修改字典
if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary is not empty.")
}

airports["LHR"] = "London"

airports["LHR"] = "London Heathrow"

//updateValue(_:forKey:) 方法会返回对应值类型的可选类型
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}

//使用下标语法来在字典中检索特定键对应的值
if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airports dictionary.")
}

//字典遍历
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}
```

## 集合

集合用来存储相同类型并且没有确定顺序的值。当集合元素顺序不重要时或者希望确保每个元素只出现一次时可以使用集合而不是数组。

一个类型为了存储在集合中，该类型必须是可哈希化的——也就是说，该类型必须提供一个方法来计算它的哈希值。一个哈希值是 `Int` 类型的，相等的对象哈希值必须相同，比如 a == b,因此必须 a.hashValue == b.hashValue。

`Swift` 的所有基本类型（如 `String`、`Int`、`Double` 和 `Bool`）默认都是可哈希化的，可以作为集合值的类型或者字典键的类型。没有关联值的枚举成员值默认也是可哈希化的。

使用自定义的类型作为集合值的类型或者是字典键的类型时，需要使自定义类型遵循 `Swift` 标准库中的 `Hashable` 协议。因为 `Hashable` 协议遵循 `Equatable` 协议，所以遵循该协议的类型也必须提供一个“是否相等”运算符（==）的实现。对于 a,b,c 三个值来说，== 的实现必须满足下面三种情况:

* a == a(自反性)
* a == b 意味着 b == a(对称性)
* a == b && b == c 意味着 a == c(传递性)

``` Swift
//创建和构造一个空的集合
var letters = Set<Character>()

//用数组字面量创建集合
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]

//访问和修改一个集合
print("I have \(favoriteGenres.count) favorite music genres.")

if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}

favoriteGenres.insert("Jazz")

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}

if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}

//集合遍历
for genre in favoriteGenres {
    print("\(genre)")
}

//基本集合操作
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

oddDigits.union(evenDigits).sorted()
oddDigits.intersection(evenDigits).sorted()
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()

//集合成员关系和相等
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

houseAnimals.isSubset(of: farmAnimals)
farmAnimals.isSuperset(of: houseAnimals)
farmAnimals.isDisjoint(with: cityAnimals)
```