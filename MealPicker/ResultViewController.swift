//
//  ResultViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/04.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var rerollButton: UIButton!
    
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
//        self.resultImageView.image = UIImage(named: "fid@\(foodID)")
        self.resultImageView.image = UIImage(systemName: "xmark")?.withTintColor(.black)
        self.resultImageView.layer.shadowColor = UIColor.black.cgColor
        self.resultImageView.layer.shadowOffset = CGSize(width: 8, height: 8)
        self.resultImageView.layer.shadowRadius = 5
        self.resultImageView.layer.shadowOpacity = 0.3
        self.resultImageView.layer.cornerRadius = 20
        self.resultImageView.contentMode = .scaleAspectFill
    }
    
    private func configureView() {
        guard let foodResult = self.foodResult else { return }
        self.configureLabel(foodName: foodResult.name)
        self.configureImageView(foodID: foodResult.foodID)
    }

    @IBAction func returnButtonTap(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: false)
    }
    
    @IBAction func rerollButtonTap(_ sender: UIButton) {
        self.pickFromList()
        guard let foodList = self.foodList else { return }
        guard let foodResult = self.foodResult else { return }
        self.configureLabel(foodName: foodResult.name)
        self.configureImageView(foodID: foodResult.foodID)
        if foodList.isEmpty {
                self.rerollButton.isHidden = true
        }
    }
}
