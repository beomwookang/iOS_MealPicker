//
//  LoadingViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/04.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    
    var foodList: [FoodDetail]?
    var isRandom: Bool = false
    
    var timeRemainingSeconds: Float = 1.5
    var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else { return }
        viewController.foodList = foodList
        viewController.modalPresentationStyle = .fullScreen
        self.configureTransition()
        self.present(viewController, animated: false)
    }
}
