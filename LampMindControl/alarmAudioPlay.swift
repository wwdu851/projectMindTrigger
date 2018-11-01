//
//  alarmAudioPlay.swift
//  LampMindControl
//
//  Created by William Du on 2017/2/4.
//  Copyright © 2017年 William Du. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

struct alarmAudioPlay{
    var AVPlayer:AVAudioPlayer?
    
    mutating func playAudioWithIdentifier(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Guitar", ofType: "mp3")!)
        do {
            AVPlayer = try AVAudioPlayer(contentsOf: url)
        }catch{
            
        }
        
        AVPlayer?.prepareToPlay()
        AVPlayer?.numberOfLoops = -1
        AVPlayer?.volume = 1.0
        AVPlayer?.play()
        
    }
}
