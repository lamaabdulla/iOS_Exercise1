//
//  Article.swift
//  IOS-Exercise
//
//  Created by Lama Alashed on 23/10/2018.
//  Copyright © 2018 Lama Alashed. All rights reserved.
//

import UIKit

class Article: Codable {
    
    //Properties
    let title: String!
    let website: String!
    let author: String!
    let date: String!
    let content: String!
    let image_url: String!
    
    //Method
    init(title: String, website: String, author: String, date: String, content: String, image_url: String ) {
        self.title = title
        self.website = website
        self.author = author
        self.date = date
        self.content = content
        self.image_url = image_url
    }
    
}

class Articles: Codable {
    
    let articles: [Article]
    
    init (articles: [Article]){
        self.articles=articles
    }
}

