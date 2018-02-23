//
//  Rectangle.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/10/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import Foundation

struct Rectangle: Decodable {
    
    // MARK: - Member variables
    var Left: Int
    var Top: Int
    var Width: Int
    var Height: Int
    
    private enum CodingKeys: String, CodingKey {
        case Left = "left"
        case Top = "top"
        case Width = "width"
        case Height = "height"
    }
    
    // MARK: - Constructors
    init() {
        self.Left = 0
        self.Top = 0
        self.Width = 0
        self.Height = 0
    }
    
    init(left: Int, top: Int, width: Int, height: Int) {
        self.Left = left
        self.Top = top
        self.Width = width
        self.Height = height
    }
    
}
