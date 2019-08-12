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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pink = UIColor("#d4237a")
        self.navigationController?.navigationBar.tintColor = pink
        
        Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        Label.numberOfLines = 0
        
        Button.waveformView = WaveformView
        
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
