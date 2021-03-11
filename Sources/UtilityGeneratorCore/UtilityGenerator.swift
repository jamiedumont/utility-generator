//
//  File.swift
//  
//
//  Created by Jamie Dumont on 11/03/2021.
//

import Foundation
import Files

public final class UtilityGenerator {
    
    public struct Colour: Decodable {
        let name: String
        let value: String
    }
    
    private let arguments: [String]
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws {
        guard arguments.count > 1 else {
            throw Error.missingFileName
        }
        
        let fileName = arguments[1]
        
//        do {
//            try Folder.current.createFile(at: fileName)
//        } catch {
//            throw Error.failedToCreateFile
//        }
        
        do{
            let file = try Folder.home.file(at: fileName)
            let data = try file.read()
            
            let colours: [Colour] = try! JSONDecoder().decode([Colour].self, from: data)
            
            let cssTemplate = """

            .bg-[colour] {
                background-color: [value];
            }
            
            .colour-[colour] {
                color: [value];
            }

            """
            
            let cssFile = try Folder.home.createFile(named: "utilities.css")
            
            for colour in colours {
                var css = cssTemplate.replacingOccurrences(of: "[colour]", with: colour.name)
                css = css.replacingOccurrences(of: "[value]", with: colour.value)
                try cssFile.append(css)
            }
            
            
            
        } catch {
            throw Error.failedToReadFile
        }
    }
        
}

public extension UtilityGenerator {
    enum Error: Swift.Error {
        case missingFileName
        case failedToCreateFile
        case failedToReadFile
    }
}
