//
//  Attributes.swift
//  Emotion
//
//  Created by Anthony Arzola on 3/11/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import Foundation

struct Attributes: Decodable {
    
    // MARK: - Member variables
    var EmoScore: EmotionalScore
    
    private enum CodingKeys: String, CodingKey {
        case EmoScore = "emotion"
    }
    
    // MARK: - Constructors
    init() {
        self.EmoScore = EmotionalScore()
    }
    
    init(emotion: EmotionalScore) {
        self.EmoScore = emotion
    }
    
}
