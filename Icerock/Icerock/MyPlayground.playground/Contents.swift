import Foundation

if let someStringOne = readLine(), let someStringTwo = readLine() {
    func groupStudentsIsTheSame(_ stringOne: String, _ stringTwo: String) -> String {

        let group = stringOne + stringTwo

        let split = group.split(separator: ".")
        guard split.count == 2 else { return "NO" }

        var oneGroup = split[0].split(separator: ",")
        var twoGroup = split[1].split(separator: ",")

        for (index, name) in oneGroup.enumerated() {
            if let space = name.first {
                if space == " " {
                    oneGroup[index].remove(at: oneGroup[index].startIndex)
                }
            }
        }

        for (index, name) in twoGroup.enumerated() {
            if let space = name.first {
                if space == " " {
                    twoGroup[index].remove(at: twoGroup[index].startIndex)
                }
            }
        }

        let splitOneGroupOne = oneGroup[0].split(separator: " ")
        let splitTwoGroupOne = oneGroup[1].split(separator: " ")

        let splitOneGroupTwo = twoGroup[0].split(separator: " ")
        let splitTwoGroupTwo = twoGroup[1].split(separator: " ")

        let resultGroupOne = splitOneGroupOne + splitTwoGroupOne
        let resultGroupTwo = splitOneGroupTwo + splitTwoGroupTwo

        if resultGroupOne.sorted(by: >) == resultGroupTwo.sorted(by: >) {
            return "YES"
        } else {
            return "NO"
        }
    }
    print(groupStudentsIsTheSame(someStringOne, someStringTwo))
}

var someStringOne = "Иван Петров, Иванов Петр."
var someStringTwo = "Петр Иванов, Иван Петров."

func groupStudentsIsTheSame(_ stringOne: String, _ stringTwo: String) -> String {

    let group = stringOne + stringTwo

    let split = group.split(separator: ".")
    guard split.count == 2 else { return "NO" }

    var oneGroup = split[0].split(separator: ",")
    var twoGroup = split[1].split(separator: ",")

    for (index, name) in oneGroup.enumerated() {
        if let space = name.first {
            if space == " " {
                oneGroup[index].remove(at: oneGroup[index].startIndex)
            }
        }
    }

    for (index, name) in twoGroup.enumerated() {
        if let space = name.first {
            if space == " " {
                twoGroup[index].remove(at: twoGroup[index].startIndex)
            }
        }
    }

    let splitOneGroupOne = oneGroup[0].split(separator: " ")
    let splitTwoGroupOne = oneGroup[1].split(separator: " ")

    let splitOneGroupTwo = twoGroup[0].split(separator: " ")
    let splitTwoGroupTwo = twoGroup[1].split(separator: " ")

    let resultGroupOne = splitOneGroupOne + splitTwoGroupOne
    let resultGroupTwo = splitOneGroupTwo + splitTwoGroupTwo
    resultGroupOne.sorted(by: >)
    resultGroupTwo.sorted(by: >)

    if resultGroupOne.sorted(by: <) == resultGroupTwo.sorted(by: <) {
        return "YES"
    } else {
        return "NO"
    }
}
print(groupStudentsIsTheSame(someStringOne, someStringTwo))
