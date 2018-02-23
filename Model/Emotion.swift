//
//  Emotion.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/10/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import Foundation

struct Emotion: Decodable {
    
    // MARK: - Member variables
    var FaceRectangle: Rectangle
    var Scores: Score
    
    private enum CodingKeys: String, CodingKey {
        case FaceRectangle = "faceRectangle"
        case Scores = "scores"
    }
    
    // MARK: - Constructors
    init() {
        self.FaceRectangle = Rectangle()
        self.Scores = Score()
    }
    
    init(faceRectangle: Rectangle, scores: Score) {
        self.FaceRectangle = faceRectangle
        self.Scores = scores
    }
    
    // MARK: - Public methods
    func getProminentEmotion() -> (String, Double) {
        let emotions : [String:Double] = ["Anger":Scores.Anger, "Contempt":Scores.Contempt,
                                           "Disgust":Scores.Disgust, "Fear":Scores.Fear,
                                           "Happiness":Scores.Happiness, "Neutral":Scores.Neutral,
                                           "Sadness":Scores.Sadness, "Surprise":Scores.Surprise]
        
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
