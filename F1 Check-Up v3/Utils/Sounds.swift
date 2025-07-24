//
//  Sounds.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 22.07.25.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(named name: String) {
    if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Fehler beim Abspielen: \(error)")
        }
    }
}


