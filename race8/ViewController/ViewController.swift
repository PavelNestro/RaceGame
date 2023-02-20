//
//  ViewController.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 6.03.22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    private var currentAudioPlayer: AVAudioPlayer?

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var recordsButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = startButton.frame.height / 2
        optionsButton.layer.cornerRadius = startButton.frame.height / 2
       recordsButton.layer.cornerRadius = recordsButton.frame.height / 2
        title = "Menu"
       startButtonShadow()
       recordsButtonShadow()
       optionsButtonShadow()
        soundButtonPressed()
        applyMotionEffect(toView: view, magnitude: 40)
        applyMotionEffect(toView: startButton, magnitude: -50)
        applyMotionEffect(toView: optionsButton, magnitude: -50)
        applyMotionEffect(toView: recordsButton, magnitude: -50)

    }
//     attributedText()

    @IBAction func startButtonAction(_ sender: Any) {
        currentAudioPlayer?.play()
        guard let viewController = ViewControllerFactory.sheard.createStartController() else {
            print("nil")
            return
        }

        navigationController?.pushViewController(viewController, animated: true)

    }

    @IBAction func optionsButtonAction(_ sender: Any) {
        currentAudioPlayer?.play()
        let viewController = ViewControllerFactory.sheard.createOptionsController()
        navigationController?.pushViewController(viewController, animated: true)

    }

    @IBAction func recordsButtonAction(_ sender: Any) {
        currentAudioPlayer?.play()
        let viewController = ViewControllerFactory.sheard.createRecordsController()
        navigationController?.pushViewController(viewController, animated: true)

    }

    func startButtonShadow() {
        startButton.addShadow(.black, 0.2, 5, CGSize(width: 20, height: 20))
        startButton.setTitle("start".localized, for: .normal)
    }
    func recordsButtonShadow() {
        recordsButton.addShadow(.black, 0.2, 5, CGSize(width: 20, height: 20))
        recordsButton.setTitle("records".localized, for: .normal)
    }
    func optionsButtonShadow() {
        optionsButton.addShadow(.black, 0.2, 5, CGSize(width: 20, height: 20))
        optionsButton.setTitle("options".localized, for: .normal)
    }

    func soundButtonPressed() {
        if let audioFileURL = Bundle.main.url(forResource: "audioButtonPressed", withExtension: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: audioFileURL)
                player.prepareToPlay()
                player.delegate = self

                self.currentAudioPlayer = player

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    // Parallax
    func applyMotionEffect (toView view: UIView, magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        view.addMotionEffect(group)
    }

//    func attributedText(){
//        let text = "Start"
//        let text2 = ("Start" as NSString).range(of: "Start")
//        let attributedStart = NSMutableAttributedString(string: text )
//        attributedStart.addAttribute(.foregroundColor, value: UIColor.orange, range: text2)
//        attributedStart.addAttribute(.font, value: UIFont.signatria(of: 30), range: text2)
//        let textOptions = "Options"
//        let textOptions2 = ("Options" as NSString).range(of: "Options")
//        let attributedOptions = NSMutableAttributedString(string: textOptions)
//        attributedOptions.addAttribute(.foregroundColor, value: UIColor.orange, range: textOptions2)
//        attributedOptions.addAttribute(.font, value: UIFont.signatria(of: 30), range: textOptions2)
//        startButton.titleLabel?.attributedText = attributedStart
//        optionsButton.titleLabel?.attributedText = attributedOptions
//    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finish")
        // currentAudioPlayer = nil
    }
}
