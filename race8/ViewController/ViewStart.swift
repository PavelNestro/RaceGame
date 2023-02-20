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
    let dictImageWood: [String: UIImage?] = [
    "wood3": UIImage(named: "reparRoad"), "wood2": UIImage(named: "wood2")
]
    var currentAudioPlayer: AVAudioPlayer?
    static let provider = ViewStart()
    let motionManager = CMMotionManager()
    let roadLine = UIView()
    let roadView = UIView()
    var imageCar = UIImageView()
    let greenView = UIImageView()
    let greenViewSecond = UIImageView()
    let step: CGFloat = 80
    var pointHeal = 3
    var points = 0
    var timer = 0.8
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
            viewGreen()
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
        self.moveGreenViewSecond()
          Timer.scheduledTimer(withTimeInterval: timer, repeats: true) { timer in
                       self.moveGreenView()
                       self.moveRoadLine()
                       self.moveObstacleView()
                       self.moveWoodView()
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

    func viewGreen() {
        greenView.image = UIImage(named: "greenView2") // "greenView2"
        greenView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height  )
        greenView.backgroundColor = .green
        view.addSubview(greenView)
    }

    //  вью в началае старта которая уезжает и исчезает
    func moveGreenViewSecond() {
        greenViewSecond.image = UIImage(named: "greenView2") // "greenView2"
        greenViewSecond.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        greenViewSecond.backgroundColor = .green
        self.greenView.addSubview(self.greenViewSecond)
        UIView.animate(withDuration: 2.9, delay: 0.8, options: [.curveLinear]) {
            self.greenViewSecond.frame.origin.y = self.greenView.frame.height
        } completion: { (_) in
            self.greenViewSecond.removeFromSuperview()
        }
    }

    func moveGreenView() {
        let greenView = UIImageView()
        greenView.image = UIImage(named: "greenView2")
        greenView.frame.size = CGSize(width: view.frame.width, height: view.frame.height     )
        greenView.frame.origin.x = 0
        greenView.frame.origin.y = -greenView.frame.height
        self.greenView.addSubview(greenView)

        UIView.animate(withDuration: 5.8, delay: 0, options: [.curveLinear]) { // 5.8
greenView.frame.origin.y = self.greenView.frame.maxY
        } completion: { _ in

            greenView.removeFromSuperview()
            print("deleted greenView")
        }
    }

    func setupRoadView() {
        roadView.frame = CGRect(x: 40, y: 0, width: view.frame.width - 80, height: view.frame.height)
        roadView.backgroundColor = .systemGray
        view.addSubview(roadView)
        roadView.addSubview(startButton)
        roadView.addSubview(leftButton)
        roadView.addSubview(rightButton)
    }
    // Создать Линию!!!!!!!!
    func setupLineView(_ line: UIView) {
        line.frame.size = CGSize(width: 10, height: 50)
        line.frame.origin.x = self.roadView.frame.width / 2 - line.frame.width / 2
        line.frame.origin.y = -line.frame.height
        line.backgroundColor = .white
        self.roadView.addSubview(line)
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
    func setupImageObstacles(_ view: UIImageView ) {
        view.frame.size = CGSize(width: 80, height: 20)
        let xOrigin = Double.random(in: 1..<self.view.frame.width - 60.0)
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
        imageCar.image = UIImage(named: "pickUp")
        imageCar.frame.size = CGSize(width: 40, height: 80)
        imageCar.frame.origin.x = view.frame.width / 2 - imageCar.frame.width / 2
        imageCar.frame.origin.y = roadView.frame.height - 200
        self.view.addSubview(imageCar)
        imageCar.bringSubviewToFront(roadLine)
    }

    // Движение кустарников
    func moveWoodView() {
        let imageWood = UIImageView()
        let imageWood2 = UIImageView()
         setupImageWood(imageWood, imageWood2)
        imageWood.image = UIImage(named: "wood1")
        imageWood2.image = UIImage(named: "wood2")
        UIView.animate(withDuration: 3, delay: 0, options: [.curveLinear]) {
            imageWood.frame.origin.y = self.view.frame.maxY
            imageWood2.frame.origin.y = self.view.frame.maxY
        } completion: { _ in
            print("deleted")
         imageWood.removeFromSuperview()
            imageWood2.removeFromSuperview()
        }

    }

   // Движение Линии
    func moveRoadLine() {
        let roadv = UIView()
        setupLineView(roadv)
        UIView.animate(withDuration: 3, delay: 0, options: [.curveLinear]) {
        roadv.frame.origin.y = self.roadView.frame.height
            self.score()

        } completion: { _ in
            self.setupLineView(roadv)
            roadv.removeFromSuperview()
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
        roadView.addSubview(self.lablePointsScore)
        if self.points == 5 {
            print("SCORE")
            self.timer = 0.5
        }
    }

    // Движения Препятствия бревно горизонт !!!!!!!!
    func moveObstacleView() {
         let obcastleImageView = UIImageView()
        obcastleImageView.image = UIImage(named: "obcastleOne")
        self.setupImageObstacles(obcastleImageView)

        Timer.scheduledTimer(withTimeInterval: 0.26, repeats: true) { (timer1) in  // 0.032

            UIView.animate(withDuration: 0.26, delay: 0, options: [.curveLinear]) {
                obcastleImageView.frame.origin.y += self.step
                if obcastleImageView.frame.intersects(self.imageCar.frame) {
                    if self.intersect == false { // при прыжке авто выключаем бессмертие
                        self.view.bringSubviewToFront(self.imageCar)
                    } else {
                        self.shakeCarImageView()
                        UIView.animate(withDuration: 3, delay: 0, options: []) {
                                self.imageCar.alpha = 0.5
                            } completion: { _ in
                                self.imageCar.alpha = 1

                            }
                    }
                }
            } completion: { _ in
                if obcastleImageView.frame.origin.y > self.view.frame.height {
                    obcastleImageView.removeFromSuperview()
        }
    }
                if self.timerShouldInvalidate {
                    self.imageCar.removeFromSuperview()
                    obcastleImageView.removeFromSuperview()
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
        viewRepairRoad.image = dictImageWood["wood3"] as? UIImage
        Timer.scheduledTimer(withTimeInterval: 0.26, repeats: true) { (timer) in

            UIView.animate(withDuration: 0.26, delay: 0, options: [.curveLinear]) {
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
    func setupImageWood(_ view: UIImageView, _ view2: UIImageView) {

        view.frame.size = CGSize(width: 40, height: 40)
        view2.frame.size = CGSize(width: 40, height: 40)
        view.frame.origin.x = view.frame.minX
        view.frame.origin.y = -view.frame.height
        view2.frame.origin.x = self.view.frame.width - 40
        view2.frame.origin.y = -view2.frame.height
        self.view.addSubview(view)
        self.view.addSubview(view2)

    }
    // создать препятствия ремонт дороги!!!!
    func setupRepairObcastle(_ view: UIImageView) {
        view.frame.size = CGSize(width: 40, height: 40)
        let xOrigin = Double.random(in: 1..<self.roadView.frame.width)
        view.frame.origin.x = xOrigin
        view.frame.origin.y = -view.frame.height
        view.backgroundColor = .clear
        roadView.addSubview(view)
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
