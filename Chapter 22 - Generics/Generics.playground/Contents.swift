import UIKit

struct StackIterator<T>: IteratorProtocol {
    var stack: Stack<T>
    
    mutating func next() -> T? {
        return stack.pop()
    }
}

struct Stack<Element>: Sequence {
    var items = [Element]()
    
    mutating func push(newItem: Element) {
        items.append(newItem)
    }
    
    mutating func pop() -> Element? {
        guard !items.isEmpty else {
            return nil
        }
        
        return items.removeLast()
    }
    
    func map<U>(f: (Element) -> U) -> Stack<U> {
        var mappedItems = [U]()
        for item in items {
            mappedItems.append(f(item))
        }
        return Stack<U>(items: mappedItems)
    }
    
    // Bronze challenge:
    func filter(f: (Element) -> Bool) -> Stack<Element> {
        var filteredItems = [Element]()
        for item in items {
 
            if f(item) {
                filteredItems.append(item)
            }
        }
        
        return Stack<Element>(items: filteredItems)
    }
    
    func makeIterator() -> StackIterator<Element> {
        return StackIterator(stack: self)
    }
}

var myStack = Stack<Int>()
myStack.push(newItem: 10)
myStack.push(newItem: 20)
myStack.push(newItem: 30)

var myStackIterator = StackIterator(stack: myStack)
while let value = myStackIterator.next() {
    print("got \(value)")
}

for value in myStack {
    print("for-in loop: got \(value)")
}

var intStack = Stack<Int>()
intStack.push(newItem: 1)
intStack.push(newItem: 2)
var doubleStack = intStack.map(f: {2 * $0})

print(intStack.pop())
print(intStack.pop())
print(intStack.pop())

print(doubleStack.pop())
print(doubleStack.pop())

var stringStack = Stack<String>()
stringStack.push(newItem: "this is a string")
stringStack.push(newItem: "another string")

print(stringStack.pop())

func myMap<T,U>(items: [T], f: (T) -> (U)) -> [U] {
    var result = [U]()
    for item in items {
        result.append(f(item))
    }
    
    return result
}

let strings = ["one", "two", "three"]
let stringLengths = myMap(items: strings) {$0.characters.count}
print(stringLengths)

func checkIfEqual<T: Equatable>(first: T, second: T) -> Bool {
    return first == second
}

print(checkIfEqual(first: 1, second: 1))
print(checkIfEqual(first: "a string", second: "a string"))
print(checkIfEqual(first: "bob", second: "tom"))

func checkIfDescriptionsMatch<T: CustomStringConvertible, U: CustomStringConvertible>(first: T, second: U) -> Bool { // T U allow for different types to be used that conform to CustomStringConvertible e.g. a String and an Int
    return first.description == second.description
}

print(checkIfDescriptionsMatch(first: 1, second: 1))
print(checkIfDescriptionsMatch(first: 1, second: "something"))

func pushItemsOntoStack<Element, S: Sequence>(stack: inout Stack<Element>, fromSequence sequence: S) where S.Iterator.Element == Element {
    for item in sequence {
        stack.push(newItem: item)
    }
}

var myOtherStack = Stack<Int>()
pushItemsOntoStack(stack: &myOtherStack, fromSequence: [1,2,3])
pushItemsOntoStack(stack: &myStack, fromSequence: myOtherStack)
for value in myStack {
    print("after pushing: got \(value)")
}

//Bronze Challenge:

var bronzeStack = Stack<Int>()
pushItemsOntoStack(stack: &bronzeStack, fromSequence: [1,2,3,4])

for value in bronzeStack.filter(f: {$0 == 1 || $0 == 4}) {
    print("after filtering: got \(value)")
}

//Silver Challenge:

func findAll<T: Equatable>(values: [T], target: T) -> [Int] {
    var indexes = [Int]()
    for (idx, value) in values.enumerated() {
        if value == target {
            indexes.append(idx)
        }
    }
    return indexes
}

findAll(values: [5,3,7,3,9], target: 3)

//Gold Challenge:

func findAll<T: Equatable, C: Collection>(values: C, target: T) -> [C.Index]? where C.Iterator.Element == T {
    var indexes = Array<C.Index>()
    for value in values {
        if value == target {
            indexes.append(values.index(of: value)!)
        }
    }
    return indexes
}

findAll(values: [5,3,7,3,9,5], target: 5)
