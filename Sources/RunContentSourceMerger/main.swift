import Foundation
import Files

let allContentSources = try Folder(path: "ContentSources")
    .files
    .map { file throws -> String in
        try file.readAsString()
    }
    .joined(separator: "\n")

let sourceFileContents = """
// This file is autogenerated by RunContentSourceMerger
import Foundation

public enum AllContentSourceProviders {
    public static var allContentSourceProviders = [
\(allContentSources)
    ]
}
"""

let folder = try Folder(path: "Sources/SwiftLearningCommon/Models/ContentSources")
let file = try folder.createFile(named: "AllContentSourceProviders.swift")
try file.write(sourceFileContents)