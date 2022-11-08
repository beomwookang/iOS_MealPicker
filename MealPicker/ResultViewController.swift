//
//  ResultViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/04.
//

import UIKit
import Lottie

class ResultViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView! {
        didSet {
            self.resultImageView.layer.shadowColor = UIColor.black.cgColor
            self.resultImageView.layer.shadowOffset = CGSize(width: 8, height: 8)
            self.resultImageView.layer.shadowRadius = 5
            self.resultImageView.layer.shadowOpacity = 0.3
            self.resultImageView.layer.cornerRadius = 20
            self.resultImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var rerollButton: UIButton!
    
    private var animationView: LottieAnimationView?
    
    var foodList: [FoodDetail]?
    var foodResult: FoodDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickFromList()
        self.configureView()
        guard let foodList = self.foodList else { return }
        if foodList.isEmpty {
            self.rerollButton.isHidden = true
        } else {
            self.rerollButton.isHidden = false
        }
        self.showLottieAnimation("result_pop", .scaleAspectFill, 1.5)
    }
    
    func showLottieAnimation(_ name: String, _ contentMode: UIView.ContentMode, _ speed: CGFloat) {
        self.animationView = .init(name: name)
        self.animationView?.frame = self.view.bounds
        self.animationView?.contentMode = contentMode
        self.animationView?.loopMode = .playOnce
        self.animationView?.animationSpeed = speed
        self.view.addSubview(self.animationView!)
        self.animationView?.play { [weak self] _ in
            self?.animationView?.removeFromSuperview()
        }
    }
    
    private func pickFromList() {
        guard var foodList = self.foodList, foodList.count >= 1 else { return }
        if let index = foodList.indices.randomElement() {
            let foodResult = foodList.remove(at: index)
            self.foodResult = foodResult
            self.foodList = foodList
        }
    }
    
    private func configureLabel(foodName: String) {
        self.resultLabel.text = foodName
        self.resultLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    }
    
    private func configureImageView(foodID: Int) {
        self.resultImageView.image = UIImage(systemName: "xmark")?.withTintColor(.black)
//        self.resultImageView.layer.shadowColor = UIColor.black.cgColor
//        self.resultImageView.layer.shadowOffset = CGSize(width: 8, height: 8)
//        self.resultImageView.layer.shadowRadius = 5
//        self.resultImageView.layer.shadowOpacity = 0.3
//        self.resultImageView.layer.cornerRadius = 20
//        self.resultImageView.contentMode = .scaleAspectFill
    }
    
    private func configureView() {
        guard let foodResult = self.foodResult else { return }
        self.resultLabel.text = foodResult.name
        self.resultLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        //self.resultImageView.image = UIImage(name: "fid@\(foodResult.foodID)") ?? UIImage(systemName: "xmark")?.withTintColor(.black)
        self.resultImageView.image = UIImage(systemName: "xmark")?.withTintColor(.black)        //temporary image
    }
    
    private func updateResultImage(foodID: Int) {
        UIView.transition(with: self.resultImageView!,
                          duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
            self.resultImageView?.image = UIImage(systemName: "xmark")?.withTintColor(.black)   //temporary image
                }, completion: nil)
    }
    
    func configureTransitionToRoot() {
        let transition = CATransition()
        transition.duration = 0.75
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }

    @IBAction func returnButtonTap(_ sender: UIButton) {
        self.configureTransitionToRoot()
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @IBAction func rerollButtonTap(_ sender: UIButton) {
        self.showLottieAnimation("reroll_pop", .scaleAspectFit, 2.5)
        self.pickFromList()
        guard let foodList = self.foodList else { return }
        guard let foodResult = self.foodResult else { return }
        self.configureLabel(foodName: foodResult.name)
        self.updateResultImage(foodID: foodResult.foodID)
        if foodList.isEmpty {
                self.rerollButton.isHidden = true
        }
    }
}
