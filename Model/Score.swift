//
//  Score.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/10/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import Foundation

struct Score: Decodable {
    
    // MARK: - Data members
    var Anger: Double
    var Contempt: Double
    var Disgust: Double
    var Fear: Double
    var Happiness: Double
    var Neutral: Double
    var Sadness: Double
    var Surprise: Double
    
    private enum CodingKeys: String, CodingKey {
        case Anger = "anger"
        case Contempt = "contempt"
        case Disgust = "disgust"
        case Fear = "fear"
        case Happiness = "happiness"
        case Neutral = "neutral"
        case Sadness = "sadness"
        case Surprise = "surprise"
    }
    
    // MARK: - Constructors
    init() {
        
        self.Anger = 0.0
        self.Contempt = 0.0
        self.Disgust = 0.0
        self.Fear = 0.0
        self.Happiness = 0.0
        self.Neutral = 0.0
        self.Sadness = 0.0
        self.Surprise = 0.0
    }
    
    init(anger: Double, contempt: Double, disgust: Double, fear: Double,
         happiness: Double, neutral: Double, sadness: Double, surprise: Double) {
        
        self.Anger = anger
        self.Contempt = contempt
        self.Disgust = disgust
        self.Fear = fear
        self.Happiness = happiness
        self.Neutral = neutral
        self.Sadness = sadness
        self.Surprise = surprise
    }
    
}
