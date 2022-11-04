//
//  ViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/10/27.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainInfoButton: UIButton!
    @IBOutlet weak var mainBeginButton: UIButton!
    @IBOutlet weak var mainRandomButton: UIButton!
    var foodList: [FoodDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFoodsFromCSV()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadFoodsFromCSV()
    }

    private func parseCSVAt(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if var dataArr = dataEncoded?.components(separatedBy: "\r\n").map({$0.components(separatedBy: ",")}) {
                dataArr.removeLast()
                for dataItem in dataArr {
                    self.foodList.append(FoodDetail(dataItem: dataItem))
                }
            }
        } catch {
            print("Error reading CSV file")
        }
    }
    
    private func loadFoodsFromCSV() {
        self.foodList = []
        let path = Bundle.main.path(forResource: "FoodList", ofType: "csv")!
        parseCSVAt(url: URL(fileURLWithPath: path))
    }
    
    private func configureButtonShadow(_ button: UIButton,
                                       _ offset: CGSize,
                                       _ radius: CGFloat,
                                       _ alpha: Float) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = offset
        button.layer.shadowRadius = radius
        button.layer.shadowOpacity = alpha
    }
    
    private func configureButtons() {
        self.configureButtonShadow(self.mainInfoButton, CGSize(width: 4, height: 4), CGFloat(4), 0.25)
        self.configureButtonShadow(self.mainBeginButton, CGSize(width: 8, height: 8), CGFloat(6), 0.25)
        self.configureButtonShadow(self.mainRandomButton, CGSize(width: 6, height: 6), CGFloat(5), 0.25)
    }
    
    private func configureTransition() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }

    private func configureView() {
        self.configureButtons()
    }

    @IBAction func beginButtonTap(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TwoOptionsViewController") as? TwoOptionsViewController else { return }
        viewController.foodList = self.foodList
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    @IBAction func randomButtonTap(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController else { return }
        viewController.isRandom = true
        viewController.foodList = self.foodList
        viewController.modalPresentationStyle = .fullScreen
        self.configureTransition()
        self.present(viewController, animated: false)
    }
}
