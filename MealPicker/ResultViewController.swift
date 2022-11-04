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
    
    var foodID: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureLabel() {
        self.resultLabel.text = "뼈해장국"
        self.resultLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    }
    
    private func configureImageView() {
        self.resultImageView.image = UIImage(named: "fid@\(self.foodID)")
        self.resultImageView.layer.shadowColor = UIColor.black.cgColor
        self.resultImageView.layer.shadowOffset = CGSize(width: 8, height: 8)
        self.resultImageView.layer.shadowRadius = 5
        self.resultImageView.layer.shadowOpacity = 0.3
        self.resultImageView.layer.cornerRadius = 20
        self.resultImageView.contentMode = .scaleAspectFill
    }
    
    private func configureView() {
        self.configureLabel()
        self.configureImageView()
    }

    @IBAction func returnButtonTap(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: false)
    }
    
    @IBAction func rerollButtonTap(_ sender: UIButton) {
        self.resultLabel.text = "김밥"
        self.resultImageView.image = UIImage(named: "fid@2")
    }
}
