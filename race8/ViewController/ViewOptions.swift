//
//  ViewOptions.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 6.03.22.
//

import UIKit
import AVKit
import RealmSwift

class ViewOptions: UIViewController {
    @IBOutlet weak var speedLavelLable: UILabel!
    @IBOutlet weak var addFenceLable: UILabel!
    @IBOutlet weak var selectDifficultyLable: UILabel!
    @IBOutlet weak var enterYourNameLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lebleTextSpeedLavel: UILabel!
    @IBOutlet weak var enterNameButton: UIButton!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var switchUI: UISwitch!
    @IBOutlet weak var addAccelerometerSwitch: UISwitch!

    private var currentAudioPlayer: AVAudioPlayer?
    private let userDefaults = UserDefaults.standard
    var userArray: Results<User>?
    var user = User()
    var settings = Settings()
    var name = ""
    var switchBool = true
    var switchBollTwo = false
    var lableLevelName = "" {
        didSet {
            self.userDefaults.set(lableLevelName, forKey: UserDefaultsKeys.lableLevel.rawValue)
            self.lebleTextSpeedLavel.text = lableLevelName.localized
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        localized()
        soundButtonPressed()
        self.navigationItem.setHidesBackButton(true, animated: true)
        userArray = RealmManager.sheard.getUser()
        settings = settings.load(.userOptions)
        print("Колличество пользователей \(userArray?.count)")

        let lastValue = userDefaults.value(forKey: .lableLevel) as? String ?? ""
        lableLevelName = lastValue

        textFieldUserName.text = userArray?.last?.name
        settings.difficult = settings.difficult

        guard let lastValueSwitchUI = userDefaults.value(forKey: "switchUI") as? Bool else {
            return
        }
        guard let lastValueSwitchAccelerometer = userDefaults.value(forKey: "switch_accelerometr") as? Bool else {
            return
        }

        switchBool = lastValueSwitchUI
        switchBollTwo = lastValueSwitchAccelerometer

        if switchBool {
            switchUI.setOn(true, animated: true)
        } else {
            switchUI.setOn(false, animated: true)
        }
        if switchBollTwo {
            addAccelerometerSwitch.setOn(true, animated: true)
        } else {
            addAccelerometerSwitch.setOn(false, animated: true)
        }

        // keyboard показать и сместить
NotificationCenter.default.addObserver(self,
                                       selector: #selector(handleShowKeyBoard(_:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        // убрать и сместить назад наше место
NotificationCenter.default.addObserver(self,
                                       selector: #selector(handleHideKeyboard(_:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)

   }

    @IBAction func backButton(_ sender: Any) {

        navigationController?.popViewController(animated: true)

    }

    @IBAction func okButtonPressed(_ sender: Any) {
        currentAudioPlayer?.play()
        if let name = textFieldUserName.text, name.isEmpty == false {
            user.name = name
           // self.name = name
            if let user = userArray?.filter({$0.name == name}).first {
                print("такое имя \(user.name) уже есть")
                settings.save(settings, .userOptions)
            } else {
                RealmManager.sheard.setUser(user)
                settings.save(settings, .userOptions)
            }
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addAccelerometerPressed(_ sender: Any) {
        var switchAccelerometer: Bool
        let accelerometer: Bool
        if addAccelerometerSwitch.isOn == true {
            switchAccelerometer = true
            accelerometer = true
        } else {
            switchAccelerometer = false
            accelerometer = false
        }
        userDefaults.set(accelerometer, forKey: UserDefaultsKeys.accelerometer.rawValue)
        userDefaults.set(switchAccelerometer, forKey: "switch_accelerometr")
    }

    @IBAction func switchAddFance(_ sender: UISwitch) {
        var switchBool: Bool
        let animationObcastle: Bool
        if switchUI.isOn == true {
         animationObcastle = true
           switchBool = true
            print("true")
        } else {
            animationObcastle = false
            switchBool = false
            print("false")
        }

        userDefaults.set(animationObcastle, forKey: UserDefaultsKeys.animationObcastle.rawValue )
        userDefaults.set(switchBool, forKey: "switchUI")
        userDefaults.synchronize()
    }
    func getUser(_ name: String) -> User {
        guard let user = userArray?.filter({$0.name == name}).first else {
            return User()
        }
        return user
    }

    @IBAction func speedButtonOne(_ sender: UIButton) {
        lableLevelName  = "level 1"
        print("speed 0.8")
        settings.difficult = 0.8

    }

    @IBAction func speedButtonTwo(_ sender: UIButton) {
        lableLevelName  = "level 2"
        print("speed 0.6")
        settings.difficult = 0.6

    }

    @IBAction func speedButtonThree(_ sender: UIButton) {
        lableLevelName  = "level 3"
        print("speed 0.5")
        settings.difficult = 0.5
    }

    func soundButtonPressed() {
        if let audioFileURL = Bundle.main.url(forResource: "audioButtonBack", withExtension: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: audioFileURL)
                player.prepareToPlay()
                self.currentAudioPlayer = player

            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func localized() {
        title = "options".localized.capitalized
        enterYourNameLable.text = "enter your name".localized.capitalized
        addFenceLable.text = "add a fence".localized.capitalized
        selectDifficultyLable.text = "select difficulty".localized.capitalized
    }


@objc func handleShowKeyBoard(_ notification: Notification) { if
    let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = inset
    }
    }

    @objc func handleHideKeyboard(_ notification: Notification) {
        scrollView.contentInset = .zero
    }

}
extension ViewOptions: UITextFieldDelegate {

    // вызывается в тот момент когда мы нажимаем когда на return в keyboard на айфоне
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("should return")
// textField.resignFirstResponder() // resignFirstResponder() это объкет на котором
// сфокусирован пользователь те когда пользователь завершит печатать и нажемет return

        if textField == self.textFieldUserName {
            textFieldUserName.becomeFirstResponder()
        }
        return true
    }
}
