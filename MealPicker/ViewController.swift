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
    var remainingOptionList: [OptionType] = []
    var nextOptionType: OptionType?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadFoodsFromCSV()
        self.initializeFoodOptions()
    }
    
    private func pickOptionType() {
        if let index = self.remainingOptionList.indices.randomElement() {
            let optionType = self.remainingOptionList.remove(at: index)
            self.nextOptionType = optionType
        }
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
    
    private func initializeFoodOptions() {
        self.remainingOptionList = [
            .country,
            .isSpicy,
            .isHot,
            .isSoup,
            .carbType,
            .hasMeat,   //meatType as a consequence
            .hasSeafood //seafoodType as a consequence
        ]
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

    private func configureView() {
        self.configureButtons()
    }
    
    private func configureNextViewController(viewController: OptionViewController) -> OptionViewController? {
        guard let nextOptionType = self.nextOptionType else { return nil }
        viewController.remainingOptionList = self.remainingOptionList
        viewController.foodList = self.foodList
        viewController.optionType = nextOptionType
        viewController.validOptionIndices = [Int](0..<optionCaseCount[nextOptionType]!)    //every options for initial choice must be valid
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

    @IBAction func beginButtonTap(_ sender: UIButton) {
        self.pickOptionType()
        guard let nextOptionType = self.nextOptionType else { return }
        switch optionCaseCount[nextOptionType] {
        case 2:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "TwoOptionsViewController") as? TwoOptionsViewController else { return }
            guard let viewController = self.configureNextViewController(viewController: initViewController) as? TwoOptionsViewController else { return }
            self.configureTransition()
            self.present(viewController, animated: true)
        case 3:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "ThreeOptionsViewController") as? ThreeOptionsViewController else { return }
            guard let viewController = self.configureNextViewController(viewController: initViewController) as? ThreeOptionsViewController else { return }
            self.configureTransition()
            self.present(viewController, animated: true)
        case 4:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "FourOptionsViewController") as? FourOptionsViewController else { return }
            guard let viewController = self.configureNextViewController(viewController: initViewController) as? FourOptionsViewController else { return }
            self.configureTransition()
            self.present(viewController, animated: true)
        case 5:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "FiveOptionsViewController") as? FiveOptionsViewController else { return }
            guard let vieWController = self.configureNextViewController(viewController: initViewController) as? FiveOptionsViewController else { return }
            self.configureTransition()
            self.present(vieWController, animated: true)
        default:
            break
        }
        let viewControllerID: String = {
            switch optionCaseCount[nextOptionType] {
            case 2:
                return "TwoOptionsViewController"
            case 3:
                return "ThreeOptionsViewController"
            case 4:
                return "FourOptionsViewController"
            case 5:
                return "FiveOptionsViewController"
            default:
                return "Nil"
            }
        }()
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: viewControllerID) as? TwoOptionsViewController else { return }
        viewController.remainingOptionList = self.remainingOptionList
        viewController.foodList = self.foodList
        viewController.optionType = nextOptionType
        viewController.validOptionIndices = [Int](0..<optionCaseCount[nextOptionType]!)    //every options for initial choice must be valid
        viewController.oldProgress = 0.0
        viewController.modalPresentationStyle = .fullScreen
        self.configureTransition()
        self.present(viewController, animated: false)
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

extension UIViewController {
    func configureTransition() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }
}
