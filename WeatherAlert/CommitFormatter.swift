import Foundation
import UIKit

struct CommitFormatter {
    static func formatt(commit: String) -> NSAttributedString {
        let result = NSMutableAttributedString()
        var specialIndex = 0
        var specialCharacter: Character?
        for (index, char) in commit.enumerated() {
            if !["@", "#", "$"].contains(char) {
                continue
            }
            let startIndex = commit.index(commit.startIndex, offsetBy: specialIndex)
            let endIndex = commit.index(commit.startIndex, offsetBy: index)
            let substring = String(commit[startIndex..<endIndex])
            if specialCharacter == char {
                switch char {
                case "@":
                    result.append(NSAttributedString(string: substring, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]))
                case "$":
                    result.append(NSAttributedString(string: substring, attributes: [.font: UIFont.italicSystemFont(ofSize: 16)]))
                default:
                    break
                }
                specialCharacter = nil
            } else {
                result.append(NSAttributedString(string: substring, attributes: [.font: UIFont.systemFont(ofSize: 16)]))
                specialCharacter = char
            }
            specialIndex = index + 1
        }
        if specialIndex < commit.count {
            let startIndex = commit.index(commit.startIndex, offsetBy: specialIndex)
            result.append(NSAttributedString(string: String(commit[startIndex...]), attributes: [.font: UIFont.systemFont(ofSize: 16)]))
        }
        return result
    }


    //just an idea i was toying with for a couple of mins
    static func testFormatt(commit: String, chars: [Character] = ["@", "#", "$"]) -> NSAttributedString {
        if chars.isEmpty {
            return NSAttributedString(string: commit, attributes: [.font: UIFont.systemFont(ofSize: 16)])
        }
        var newChars = chars
        let char = chars[0]
        newChars.removeFirst()
        let parts = commit.split(separator: char)
        return parts.enumerated().reduce(NSMutableAttributedString()) { partialResult, part in
            if part.offset % 2 == (chars.contains(commit.first ?? Character("")) ? 1 : 0) {
                partialResult.append(testFormatt(commit: String(part.element), chars: newChars))
            } else {
                switch char {
                case "@":
                    partialResult.append(NSAttributedString(string: String(part.element), attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]))
                case "$":
                    partialResult.append(NSAttributedString(string: String(part.element), attributes: [.font: UIFont.italicSystemFont(ofSize: 16)]))
                default:
                    break
                }
            }
            return partialResult
        }
    }
}
