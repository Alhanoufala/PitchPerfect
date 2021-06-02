//
//  RecoredSoundViewController.swift
//  pitchPerfect
//
//  Created by Alhanouf Alawwad on 14/10/1442 AH
//

import UIKit
import AVFoundation

class RecoredSoundViewController: UIViewController  , AVAudioRecorderDelegate  {
    // MARK: Outlets
    @IBOutlet weak var recordingLabel: UILabel!    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
    }
    
    // MARK: Actions
    @IBAction func recoredButton(_ sender: Any) {
        
        configureUI(false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        configureUI(true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecoreding", sender: audioRecorder.url)
        }
        else{
            print("Recoreding was not successful")
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecoreding" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
        
        
    }
    func configureUI(_ state: Bool) {
        recordButton.isEnabled = state
        stopRecordingButton.isEnabled = !state
        recordingLabel.text = state ? "Tap to Record" : "Recording in Progress"
    }
    
    
}


