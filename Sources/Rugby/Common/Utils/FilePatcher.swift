//
//  FilePatcher.swift
//  Rugby
//
//  Created by Vyacheslav Khorkov on 03.03.2021.
//  Copyright © 2021 Vyacheslav Khorkov. All rights reserved.
//

import Files
import Foundation

struct FilePatcher {
    /// Replacing content of each file by regex criteria in selected folder.
    func replace(_ lookup: String,
                 with replace: String,
                 inFilesByRegEx fileRegEx: String,
                 folder: Folder) throws {
        let regex = try fileRegEx.regex()
        for file in folder.files.recursive where file.path.match(regex) {
            try autoreleasepool {
                var content = try file.readAsString()

                content.enumerateLines { line, _ in
                    print(line)
                }

                content = content.replacingOccurrences(of: lookup, with: replace, options: .regularExpression)
                try file.write(content)
            }
        }
    }
//
    func replaceDryRun(_ lookup: String,
                 with replace: String,
                 inFilesByRegEx fileRegEx: String,
                 folder: Folder) throws {
        let regex = try fileRegEx.regex()

        let lookupRegex = try! lookup.regex()

        for file in folder.files.recursive where file.path.match(regex) {
            try autoreleasepool {
                var content = try file.readAsString()

                content.enumerateLines { line, _ in
                    if hasMatches(lookupRegex, line) {
                        print("📍", line, "=>", replace)
                    }
                }

//                content = content.replacingOccurrences(of: lookup, with: replace, options: .regularExpression)
//                try file.write(content)
            }
        }
    }

    func modify(
        inFilesByRegEx fileRegEx: String,
        folder: Folder,
        modifier: @escaping (File, String) -> [String]
    ) throws {

        let regex = try fileRegEx.regex()

        for file in folder.files.recursive where file.path.match(regex) {

            let content = try file.readAsString()

            var modifiedLines: [String] = []
            content.enumerateLines { line, _ in
                modifiedLines += modifier(file, line)
            }

            try file.write(
                modifiedLines.joined(separator: "\n")
                    .data(using: .utf8)!
            )

        }

    }
}

func hasMatches(_ regex: NSRegularExpression, _ string: String) -> Bool {
    return regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) != nil
}
