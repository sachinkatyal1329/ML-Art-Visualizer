//
//  FileHandler.swift
//  Art App
//
//  Created by Sachin Katyal on 7/8/19.
//  Copyright © 2019 Sachin Katyal. All rights reserved.
//

import Foundation

class FileHandler {
    
    var fileName: String!
    
    var categories: [String]!
    
    init(fileName: String) {
        self.fileName = fileName
        read()
    }
    
    private func read(){
        var text = String()
        
        let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt")
        
        do {
            text = try String(contentsOf: fileURL!, encoding: .utf8)
            categories = text.components(separatedBy: .newlines)
        } catch {
            print("Unable to Read from File")
        }
    }
    
    func getImageURL() -> String{
        var imageURL = categories[0]
        imageURL = imageURL.components(separatedBy: ":")[1]
        return imageURL
    }
    
    func getTitle() -> String {
        var title = categories[7]
        title = title.components(separatedBy: ":")[1]
        return title
    }
    
    func getAuthorName() -> String{
        var authorName = categories[1]
        authorName = authorName.components(separatedBy: ":")[1]
        return authorName
    }
    
    func getDimensions() -> String{
        var dimensions = categories[2]
        dimensions = dimensions.components(separatedBy: ":")[1]
        return dimensions
    }
    
    func getDateCreated() -> String {
        var dateCreated = categories[3]
        dateCreated = dateCreated.components(separatedBy: ":")[1]
        return dateCreated
    }
    
    func getMedium() -> String {
        var medium = categories[4]
        medium = medium.components(separatedBy: ":")[1]
        return medium
    }
    
    func getDescription() -> String {
        var description = categories[5]
        description = description.components(separatedBy: ":")[1]
        return description
    }

    func getAuthorDescription() -> String {
        var authorDesc = categories[6]
        authorDesc = authorDesc.components(separatedBy: ":")[1]
        return authorDesc
    }
    
}
