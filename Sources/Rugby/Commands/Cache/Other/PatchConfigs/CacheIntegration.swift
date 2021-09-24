//
//  CacheIntegration.swift
//  Rugby
//
//  Created by Vyacheslav Khorkov on 31.01.2021.
//  Copyright © 2021 Vyacheslav Khorkov. All rights reserved.
//

import Files

struct CacheIntegration {
    let cacheFolder: String
    let buildedTargets: Set<String>

    func replacePathsToCache() throws {
        let supportFilesFolder = try Folder.current.subfolder(at: .podsTargetSupportFiles)
        let originalDirs = ["PODS_CONFIGURATION_BUILD_DIR", "BUILT_PRODUCTS_DIR"].joined(separator: "|")
        let suffixPods = buildedTargets.map { $0.escapeForRegex() }.joined(separator: "|")
        let fileRegex = [#".*-resources\.sh"#, #".*\.xcconfig"#, #".*-frameworks\.sh"#].joined(separator: "|")
        try FilePatcher().replaceDryRun(#"\$\{(\#(originalDirs))\}(?=\/(\#(suffixPods))("|\s|\/))"#,
                                  with: cacheFolder,
                                  inFilesByRegEx: "(\(fileRegex))",
                                  folder: supportFilesFolder)

//        do {
//            try FilePatcher().modify(inFilesByRegEx: #"(.*-resources\.sh)"#, folder: supportFilesFolder, modifier: { _, line in
//                print(line)
//                return [line]
//            })
//        }
//
//        do {
//            try FilePatcher().modify(inFilesByRegEx: #"(.*\.xcconfig)"#, folder: supportFilesFolder, modifier: { _, line in
//                print(line)
//                return [line]
//            })
//        }
//
//        do {
//            try FilePatcher().modify(inFilesByRegEx: #"(.*-frameworks\.sh)"#, folder: supportFilesFolder, modifier: { _, line in
//                print(line)
//                return [line]
//            })
//        }


    }
}
