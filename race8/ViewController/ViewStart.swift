//
//  ViewStart.swift
//  lesson8_HM(race)
//
//  Created by Pavel Nesterenko on 6.03.22.
//

import UIKit
import AVKit
import CoreMotion
import QuartzCore
// swiftlint:disable type_body_length
class ViewStart: UIViewController {
    @IBOutlet weak var healPointsTextLabel: UILabel!
    @IBOutlet weak var lablePointsScore: UILabel!
    @IBOutlet weak var healImageView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    let arrayCar = [UIImage(named: "carRed"), UIImage(named: "carYellow"), UIImage(named: "carGreen"), UIImage(named: "carGrey"), UIImage(named: "carBlue")]
    let arrayCarOpposite = [UIImage(named: "orangeCar"), UIImage(named: "policeCar"), UIImage(named: "redWhiteCar"), UIImage(named: "salatCar")]
    let stoneArray = [UIImage(named: "stoneOne"), UIImage(named: "stoneTwo")]
    
    var currentAudioPlayer: AVAudioPlayer?
    static let provider = ViewStart()
    let motionManager = CMMotionManager()
    let roadLine = UIView()
    let viewSecond = UIView()
    let roadView = UIImageView()
    var imageCar = UIImageView()
    let greenViewSecond = UIImageView()
    let step: CGFloat = 40
    var pointHeal = 9
    var points = 0
    var timer = 1.4
    var timerShouldInvalidate = false
    var animationRepairObcastels = false
    var accelerometer = false
    var intersect = true

    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "ru")
        return dateFormatter
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            soundButtonPressed()
            startButton.setTitle("start".localized, for: .normal)
            loadOptionsForGame()
            loadUserDifficult()
            setupClearView()
            setupRoadView()
            setupCarImageView(imageCar)
            view.addSubview(healImageView)
            view.addSubview(healPointsTextLabel)
            self.navigationItem.setHidesBackButton(true, animated: true)
            let userObject = RealmManager.sheard.getUser()
            print("Количество объектов класса User \(userObject.count)")
            print(timer)
        }

    @IBAction func startButtonAction(_ sender: Any) {
        currentAudioPlayer?.play()
        UIView.animate(withDuration: 1, delay: 0, options: []) {
            self.startButton.alpha = 0
            self.leftButton.backgroundColor = .clear
            self.rightButton.backgroundColor = .clear
        } completion: { _ in
            if self.accelerometer == true {
                self.onAccelerometer()
                self.rightButton.isEnabled = false
                self.leftButton.isEnabled = false
            }
        }
            Timer.scheduledTimer(withTimeInterval: self.timer, repeats: false) { timer in
                self.moveRoadViewSecond()
        }
            Timer.scheduledTimer(withTimeInterval: self.timer, repeats: true) { timer in
                self.moveRoadView()
                self.moveRandomCar()
                self.moveRandomCarOpposite()
                self.moveStoneView()
                if self.timerShouldInvalidate {
                    timer.invalidate()  // эта функция остановит таймер
            }
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            if self.animationRepairObcastels == true {
                self.moveRepairObcastelsView()
                self.moveBigObstacleView()
            }
            if self.timerShouldInvalidate {
                timer.invalidate()
            }

    }
    }

    @IBAction func rightButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            if self.imageCar.frame.width <= self.view.frame.width {
                self.imageCar.frame.origin.x += 30
                self.crushCar()
            }
        } completion: { _ in
        }
    }

    @IBAction func leftButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            if self.imageCar.frame.width >= self.view.frame.minX {
                self.imageCar.frame.origin.x -= 30
                self.crushCar()
            }
        } completion: { _ in
        }
    }

    func onAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1/60
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    if self.imageCar.frame.width >= self.view.frame.minX {
                        self.imageCar.frame.origin.x += data.acceleration.x * 10
                        self.crushCar()
                    }
                }
            }
        }
    }
    func moveRoadViewSecond() {
        roadView.image = UIImage(named: "road2") // "greenView2"
        roadView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

       viewSecond.addSubview(roadView)
        UIView.animate(withDuration: 1.6, delay: 0, options: [.curveLinear]) {
            self.roadView.frame.origin.y = self.view.frame.height
        } completion: { (_) in
            self.roadView.removeFromSuperview()
        }
    }
    
    func moveRoadView() {
        let roadView = UIImageView()
        roadView.image = UIImage(named: "road")
        roadView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        roadView.frame.origin.x = 0
        roadView.frame.origin.y = -roadView.frame.height
        viewSecond.addSubview(roadView)

        UIView.animate(withDuration: 3, delay: 0, options: [.curveLinear]) { // 4
            roadView.frame.origin.y = self.view.frame.maxY
            self.score()
        } completion: { _ in

            roadView.removeFromSuperview()
            print("deleted greenView")
        }
    }
    
    func setupClearView() {
        viewSecond.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        viewSecond.backgroundColor = .clear
        view.addSubview(viewSecond)
    }

    func setupRoadView() {
        roadView.image = UIImage(named: "road2")
        roadView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        viewSecond.addSubview(roadView)
        view.addSubview(startButton)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
    }
    
    // тряска автомобиля
    func shakeCarImageView() {
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint: CGPoint = CGPoint(x: imageCar.center.x - 4, y: imageCar.center.y)
        let fromValue: NSValue = NSValue(cgPoint: fromPoint)
        let toPoint: CGPoint = CGPoint(x: imageCar.center.x + 4, y: imageCar.center.y)
        let toValue: NSValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        imageCar.layer.add(shake, forKey: "position")
        healPoint()
    }
    // тряска телефона авто подпрыгивает
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Device was shaked")
            UIView.animate(withDuration: 1) {
                self.imageCar.transform = CGAffineTransform.init(scaleX: 1.8, y: 1.8)
                self.intersect = false
            } completion: { _ in
                UIView.animate(withDuration: 1) {
                    self.imageCar.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                } completion: { _ in
                    self.intersect = true
                }
            }
        }
    }

    // создать картинку препятствия
    func setupRandomCar(_ view: UIImageView ) {
        view.frame.size = CGSize(width: 40, height: 80)
        let xOrigin = Double.random(in: self.view.frame.width / 2.5..<self.view.frame.width - 100.0)
        view.frame.origin.x = xOrigin
        view.frame.origin.y = -view.frame.height
        view.backgroundColor = .clear
        // self.greenView.addSubview(view)
        self.view.addSubview(view)
    }
    func setupRandomCarOpposite(_ view: UIImageView ) {
        view.frame.size = CGSize(width: 40, height: 80)
        let xOrigin = Double.random(in: view.frame.origin.x + 60.0..<self.view.frame.width / 2.8)
        view.frame.origin.x = xOrigin
        view.frame.origin.y = -view.frame.height
        view.backgroundColor = .clear
        // self.greenView.addSubview(view)
        self.view.addSubview(view)
    }
    // содать большое препятствие на весь экран
    func setupBigImageObstacles(_ view: UIImageView ) {
        view.frame.size = CGSize(width: self.view.frame.width / 2, height: 20)
        let xOrigin = self.view.frame.origin.x
        view.frame.origin.x = xOrigin
        view.frame.origin.y = -view.frame.height
        view.backgroundColor = .clear
        // self.greenView.addSubview(view)
        self.view.addSubview(view)
    }
    // Создать Машину
    func setupCarImageView(_ imageCar: UIImageView) {
        let nameCar = Settings.sheard.load(.nameCar)
        imageCar.image = UIImage(named: nameCar.nameCar)
        imageCar.frame.size = CGSize(width: 40, height: 80)
        imageCar.frame.origin.x = view.frame.width / 2 - imageCar.frame.width / 2
        imageCar.frame.origin.y = roadView.frame.height - 200
        view.addSubview(imageCar)
        imageCar.bringSubviewToFront(greenViewSecond)
    }

    // Движение кустарников
    func moveStoneView() {
        let viewStone = UIImageView()
        if let randomStone = stoneArray.randomElement() {
            viewStone.image = randomStone
        }
        setupStoneView(viewStone)

        UIView.animate(withDuration: 1.6, delay: 0, options: [.curveLinear]) {
            viewStone.frame.origin.y = self.view.frame.maxY
        } completion: { _ in
            print("deletedStone")
            viewStone.removeFromSuperview()
        }

    }

    // Crush Car
    func crushCar() {
        if (imageCar.frame.maxX > self.view.frame.width) || (imageCar.frame.origin.x < self.view.frame.minX) {
            motionManager.stopAccelerometerUpdates()
            createGameViewController()
            self.timerShouldInvalidate = true
        }
    }

    // Создать Вью Контроллер GameOver
    func createGameViewController() {
        let viewController = ViewControllerFactory.sheard.createGameOwerViewController()
        viewController.view.backgroundColor = .white
       self.navigationController?.pushViewController(viewController, animated: true)
        viewController.point = self.points
        viewController.rainbow()

        // заархивируем и сохраним в Realm
        let user = RealmManager.sheard.getUser()
        let date = Date()
        try! RealmManager.sheard.realm.write {
            user.last?.score = points
            user.last?.date = dateFormatter.string(from: date)
        }
        RealmManager.sheard.setUser(user.last ?? User())
    }

    // Счет!!!!!!!!!!!!!!
    func score() {
        let score = "score"
        self.points += 1
        self.lablePointsScore.text = "\(score.localized.capitalized): \(self.points)"
        view.addSubview(self.lablePointsScore)
        if self.points == 5 {
            print("SCORE")
            self.timer = 0.5
        }
    }

    // Движения Препятствия бревно горизонт !!!!!!!!
    func moveRandomCar() {
        let viewCar = UIImageView()
        if let randomCar = arrayCar.randomElement() {
            viewCar.image = randomCar
        }
        self.setupRandomCar(viewCar)

        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { (timer1) in  // 0.032

            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveLinear]) {
                viewCar.frame.origin.y += self.step
                if viewCar.frame.intersects(self.imageCar.frame) {
                    if self.intersect == false { // при прыжке авто выключаем бессмертие
                        self.view.bringSubviewToFront(self.imageCar)
                    } else {
                        self.shakeCarImageView()
                        UIView.animate(withDuration: 3, delay: 0, options: []) {
                                viewCar.alpha = 0.5
                            } completion: { _ in
                                viewCar.alpha = 1

                            }
                    }
                }
            } completion: { _ in
                if viewCar.frame.origin.y > self.view.frame.height {
                    viewCar.removeFromSuperview()
        }
    }
                if self.timerShouldInvalidate {
                    self.imageCar.removeFromSuperview()
                    viewCar.removeFromSuperview()
                timer1.invalidate()
            }
        }
    }
    func moveRandomCarOpposite() {
        let viewCar = UIImageView()
        if let randomCar = arrayCarOpposite.randomElement() {
            viewCar.image = randomCar
        }
        self.setupRandomCarOpposite(viewCar)

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer1) in  // 0.032

            UIView.animate(withDuration: 0.05, delay: 0, options: [.curveLinear]) {
                viewCar.frame.origin.y += self.step
                if viewCar.frame.intersects(self.imageCar.frame) {
                    if self.intersect == false { // при прыжке авто выключаем бессмертие
                        self.view.bringSubviewToFront(self.imageCar)
                    } else {
                        self.shakeCarImageView()
                        UIView.animate(withDuration: 3, delay: 0, options: []) {
                                viewCar.alpha = 0.5
                            } completion: { _ in
                                viewCar.alpha = 1

                            }
                    }
                }
            } completion: { _ in
                if viewCar.frame.origin.y > self.view.frame.height {
                    viewCar.removeFromSuperview()
        }
    }
                if self.timerShouldInvalidate {
                    self.imageCar.removeFromSuperview()
                    viewCar.removeFromSuperview()
                timer1.invalidate()
            }
        }
    }


    func moveBigObstacleView() {
        let obstacleImageView = UIImageView()
        obstacleImageView.image = UIImage(named: "twoObscatle")
        setupBigImageObstacles(obstacleImageView)
        Timer.scheduledTimer(withTimeInterval: 0.26, repeats: true) { (timer1) in  // 0.26

            UIView.animate(withDuration: 0.26, delay: 0, options: [.curveLinear]) {
                obstacleImageView.frame.origin.y += self.step
                if obstacleImageView.frame.intersects(self.imageCar.frame) {
                     print("yes!")
                        UIView.animate(withDuration: 3, delay: 0, options: []) {
                            self.imageCar.alpha = 0.5
                        } completion: { _ in
                            self.imageCar.alpha = 1
                        }
                }

            } completion: { _ in
                if obstacleImageView.frame.origin.y > self.view.frame.height {
                    obstacleImageView.removeFromSuperview()

        }
    }
                if self.timerShouldInvalidate {
                    self.imageCar.removeFromSuperview()
                    obstacleImageView.removeFromSuperview()
                timer1.invalidate()
            }
        }
    }

    // Анимация ремонт дороги 
    func moveRepairObcastelsView() {
        let viewRepairRoad = UIImageView()
        setupRepairObcastle(viewRepairRoad)
        viewRepairRoad.image = UIImage(named: "reparRoad")
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { (timer) in

            UIView.animate(withDuration: 0.07, delay: 0, options: [.curveLinear]) {
                viewRepairRoad.frame.origin.y += self.step
                if viewRepairRoad.frame.intersects(self.imageCar.frame) {
                     print("yes!")
                    self.timerShouldInvalidate = true
                    self.createGameViewController()
                }
            } completion: { (_) in
                if self.timerShouldInvalidate {
                timer.invalidate()
                self.imageCar.removeFromSuperview()
                viewRepairRoad.removeFromSuperview()
            }
            }
        }

       return
    }
    // Создать Кустарники !!!!!!
    func setupStoneView(_ view: UIImageView) {
        view.frame.size = CGSize(width: 40, height: 40)
        view.frame.origin.x = view.frame.minX
        view.frame.origin.y = -view.frame.height
        self.view.addSubview(view)
    }

    // создать препятствия ремонт дороги!!!!
    func setupRepairObcastle(_ view: UIImageView) {
        view.frame.size = CGSize(width: 40, height: 40)
        let xOrigin = Double.random(in: 1..<self.roadView.frame.width)
        view.frame.origin.x = xOrigin
        view.frame.origin.y = -view.frame.height
        view.backgroundColor = .clear
        self.view.addSubview(view)
    }
    // вытаскиваем сохранения  класс user
    func loadUserDifficult() {
        let settingDifficult = Settings.sheard.load(.userOptions)
        let userDifficult = settingDifficult.difficult
        timer = userDifficult
    }

    func loadOptionsForGame() {
        guard let lastValue = UserDefaults.standard.value(forKey: .animationObcastle) as? Bool else {
            return
    }
        guard let lastValueAccelerometer = UserDefaults.standard.value(forKey: .accelerometer) as? Bool else {
            return
        }
        animationRepairObcastels = lastValue
        accelerometer = lastValueAccelerometer
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

    func healPoint() {
        pointHeal -= 1
        print(pointHeal)
        healPointsTextLabel.text = " \(pointHeal)"
        if pointHeal == 0 {
             self.timerShouldInvalidate = true
             self.createGameViewController()
        }
    }
}
