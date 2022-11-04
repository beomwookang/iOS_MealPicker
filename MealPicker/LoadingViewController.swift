//
//  LoadingViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/04.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    
    var isRandom: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLabel()
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
    
    private func loadResult() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        self.present(viewController, animated: true)
    }
    
    @IBAction func tabShowResult(_ sender: UIButton) {
        self.loadResult()
    }
}
