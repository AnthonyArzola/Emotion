//
//  Detect.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/10/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import Foundation

struct Detect: Decodable {
    
    // MARK: - Member variables
    var FaceID: String
    var FaceRectangle: Rectangle
    var FaceAttributes: Attributes
    
    private enum CodingKeys: String, CodingKey {
        case FaceID = "faceId"
        case FaceRectangle = "faceRectangle"
        case FaceAttributes = "faceAttributes"
    }
    
    // MARK: - Constructors
    init() {
        self.FaceID = ""
        self.FaceRectangle = Rectangle()
        self.FaceAttributes = Attributes()
    }
    
    init(faceId: String, faceRectangle: Rectangle, faceAttributes: Attributes) {
        self.FaceID = faceId
        self.FaceRectangle = faceRectangle
        self.FaceAttributes = faceAttributes
    }
    
    // MARK: - Public methods
    func getProminentEmotion() -> (String, Double) {
        
        let emotions : [String:Double] = ["Anger":FaceAttributes.EmoScore.Anger,
                                          "Contempt":FaceAttributes.EmoScore.Contempt,
                                          "Disgust":FaceAttributes.EmoScore.Disgust,
                                          "Fear":FaceAttributes.EmoScore.Fear,
                                          "Happiness":FaceAttributes.EmoScore.Happiness,
                                          "Neutral":FaceAttributes.EmoScore.Neutral,
                                          "Sadness":FaceAttributes.EmoScore.Sadness,
                                          "Surprise":FaceAttributes.EmoScore.Surprise]
        
        let emotionTuple = emotions.max { $0.1 < $1.1}
        
        return emotionTuple!
    }
    
    func getProminetEmotionWithEmoji() -> (String, String, Double) {
        let prominentEmotion = getProminentEmotion()
        let emoji: String?
        
        switch prominentEmotion.0 {
        case "Anger":
            emoji = "😡"
            break;
        case "Contempt":
            emoji = "🙄"
            break;
        case "Disgust":
            emoji = "🤮"
            break;
        case "Fear":
            emoji = "🙀"
            break;
        case "Happiness":
            emoji = "🙂"
            break;
        case "Neutral":
            emoji = "😐"
            break;
        case "Sadness":
            emoji = "😢"
            break;
        case "Surprise":
            emoji = "😯"
            break;
        default:
            emoji = "😶"
        }
        
        let emotionTuple = (prominentEmotion.0, emoji!, prominentEmotion.1)
        
        return emotionTuple
    }
    
}
