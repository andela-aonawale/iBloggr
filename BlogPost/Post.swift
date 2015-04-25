//
//  Post.swift
//  BlogPost
//
//  Created by Andela Developer on 4/24/15.
//  Copyright (c) 2015 Andela. All rights reserved.
//

import Foundation

class Post {
    var id:String = ""
    var title:String = ""
    var post:String = ""
    var author:String = ""
    var created_on:String = ""
    var updated_on:String = ""
    
    init(id:String, title:String, author:String, post:String, created_on:String, updated_on:String) {
        self.id = id
        self.title = title
        self.author = author
        self.post = post
        self.created_on = created_on
        self.updated_on = updated_on
    }
}
