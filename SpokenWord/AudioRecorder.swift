//
//  AudioRecorder.swift
//  record-audio
//
//  Created by birkan kolcu on 9/25/20.
//  Copyright © 2020 autonomic-computing-lab. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation


class AudioRecorder: NSObject,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    var AudioRecordButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var AudioPlayButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    
    func loadAudioRecordingUI(drawview: UIView) {
        AudioRecordButton = UIButton(frame: CGRect(x: 264, y: 464, width: 228, height: 64))
        AudioRecordButton.setTitle("Tap to Record", for: .normal)
        AudioRecordButton.backgroundColor = UIColor.red
        AudioRecordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        AudioRecordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        drawview.addSubview(AudioRecordButton)
        
        AudioPlayButton = UIButton(frame: CGRect(x: 564, y: 464, width: 228, height: 64))
        AudioPlayButton.setTitle("Tap to Play", for: .normal)
        AudioPlayButton.backgroundColor = UIColor.blue
        AudioPlayButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        AudioPlayButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        drawview.addSubview(AudioPlayButton)
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            AudioRecordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            print("audio is saved \(getDocumentsDirectory().appendingPathComponent("recording.m4a"))")
            
            AudioRecordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            AudioRecordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    @objc func playTapped() {
        var error : NSError?
        do {
            let player = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
             audioPlayer = player
         } catch {
             print(error)
         }

        audioPlayer?.delegate = self

        if let err = error{
            print("audioPlayer error: \(err.localizedDescription)")
        }else{
            print("play audio")
            audioPlayer?.play()
        }
       
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
