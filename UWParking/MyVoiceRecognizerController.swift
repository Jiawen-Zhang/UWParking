//
//  MyVoiceRecognizerController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-08-07.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift
import SpeechRecognizerButton


class MyVoiceRecognizerController: UIViewController{
    
    
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var Button: SFButton!
    
    @IBOutlet weak var WaveformView: SFWaveformView!
    
    
    //*** Test for NLP ***
    
    let inputString = "Navigate to M3"
    
    
    // tag schemes: tag schemes are constants that are used to identify pieces of information that we want from the input text. Tag schemes asks tagger to look for informations like
    // Token type: a contant to classify each character as a word, punctuation or a whitespace
    // Language: a constant to determine langugage of the token
    // LexicalClass: this constant determines class of each token. i.e. it determines part of speech for a word, type of punctuation for a punctuation or type of whitespace for a whitespace
    // Name type: this constant looks for tokens that are part of a named entity. It will look for a person's name , organizational name and name of a place
    // Lemma: this constant returns the stem of word.
    let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    
    // Options are the way to tell API as how to split the text. We are asking to ignore any punctuations and any whitespaces. Also, if there is a named entity then join it together i.e instead of considering "New" "Delhi" as two entities, join them together as one which is "New Delhi"
    
    let options: NSLinguisticTagger.Options = [NSLinguisticTagger.Options.omitPunctuation, .omitWhitespace, .joinNames]
    
    // Parts of Speech
    
    func partOfSpeech() {
        tagger.string = inputString
        let range = NSRange(location: 0, length: inputString.utf16.count)
        
        tagger.enumerateTags(in: range, unit: NSLinguisticTaggerUnit.word, scheme: NSLinguisticTagScheme.lexicalClass, options: options) { (tag, tokenRange, _) in
            if let tag = tag {
                let word = (inputString as NSString).substring(with: tokenRange)
                print("\(tag.rawValue) -> \(word)")
            }
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pink = UIColor("#d4237a")
        self.navigationController?.navigationBar.tintColor = pink
        
        Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        Label.numberOfLines = 0
        
        Button.waveformView = WaveformView
        
        //*** Test for NLP ***
        partOfSpeech()
        
        //self.Button
        
        
        Button.resultHandler = {
            self.Label.text = $1?.bestTranscription.formattedString
            //self.Button.play()
        }
        Button.errorHandler = {
            self.Label.text = $0?.localizedDescription
        }
        
    }
    
}
