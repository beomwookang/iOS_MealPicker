//
//  LoadingViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/04.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet var animationView: LottieAnimationView!
    
    let weightedPossibility: [Int] = Array(1...10)
    let loadAnimationList = ["thinking", "cooking", "cooking2"]
    
    var foodList: [FoodDetail]?
    var isRandom: Bool = false
    
    var timeRemainingSeconds: Float = 2.5
    var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLottieAnimation()
        self.startTimer()
    }
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 0.1)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.timeRemainingSeconds -= 0.1
                if self.timeRemainingSeconds <= 0 {
                    self.stopTimer()
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        self.timer?.cancel()
        self.timer = nil
        guard let foodList = self.foodList else { return }
        self.loadResult(foodList)
    }
    
    func showLottieAnimation() {
        let randomElem: Int = self.weightedPossibility.randomElement()!
        var lottieName: String = "thinking"
        switch randomElem {                         //For weighted randomisation
        case 1, 2, 3, 4, 5:
            lottieName = "thinking"
        case 6, 7, 8:
            lottieName = "cooking"
        case 9, 10:
            lottieName = "cooking2"
        default:
            lottieName = "thinking"
        }
        let randomAnimation = LottieAnimation.named("loading_\(lottieName)")
        self.animationView!.animation = randomAnimation
        self.animationView!.isHidden = false
        self.animationView!.loopMode = .loop
        self.animationView!.animationSpeed = 1.5
        self.view.addSubview(self.animationView!)
        self.animationView!.play()
    }
    
    private func configureLabel() {
        if self.isRandom {
            loadingLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
            loadingLabel.text = "랜덤으로 메뉴 선택 중"
        } else {
            loadingLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
            loadingLabel.text = "메뉴 고르는 중"
        }
    }
    
    private func configureView() {
        self.configureLabel()
    }
    
    private func loadResult(_ foodList: [FoodDetail]) {
        self.animationView!.isHidden = true
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else { return }
        viewController.foodList = foodList
        viewController.modalPresentationStyle = .fullScreen
        self.configureTransition()
        self.present(viewController, animated: false)
    }
}
