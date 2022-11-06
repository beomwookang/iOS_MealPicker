//
//  OptionViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/01.
//

import UIKit

class OptionViewController: UIViewController {
    var remainingOptionList: [OptionType]?
    
    var foodList: [FoodDetail]?
    var optionType: OptionType?
    var validOptionIndices: [Int]?
    
    var nextFoodList: [FoodDetail]?
    var nextOptionType: OptionType?
    var nextValidOptionIndices: [Int]?
    
    var isLast: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let foodList = self.foodList else { return }
        guard let optionType = self.optionType else { return }
        guard let validOptionIndices = self.validOptionIndices else { return }
        self.checkIfLast()
        print("food list length: \(foodList.count)")
        print("option type: \(optionType)")
        print("valid option indices: \(validOptionIndices)")
    }
    
    func checkIfLast() {
        if let remainingOptionList = self.remainingOptionList {
            if remainingOptionList.isEmpty {
                self.isLast = true
            }
        }
        if let nextValidOptionIndices = self.nextValidOptionIndices {
            if nextValidOptionIndices.count <= 1 {
                self.isLast = true
            }
        }
    }
    
    func pickOptionType(optionIndex: Int) {
        print("\nPick Option Type Called 1\n")
        guard let optionType = self.optionType else { return }
        print("\nPick Option Type Called 2\n")
        if optionType == .hasMeat && optionIndex == 0 {                 //if choice was to have meat
            self.nextOptionType = .meatType
        } else if optionType == .hasSeafood && optionIndex == 0 {       //if choice was to have seafood
            self.nextOptionType = .seafoodType
        } else {
            guard var remainingOptionList = self.remainingOptionList else { return }
            if let index = remainingOptionList.indices.randomElement() {
                let optionType = remainingOptionList.remove(at: index)
                self.nextOptionType = optionType
                self.remainingOptionList = remainingOptionList
            }
        }
        print("\nPick Option Type Called 3\n")
        guard let nextOptionType = self.nextOptionType else { return }
        print("next option type: \(nextOptionType)")
    }
    
    func countValidOptions() {
        guard let nextOptionType = self.nextOptionType else { return }
        guard let nextFoodList = self.nextFoodList else { return }
        guard let optionCount = optionCaseCount[nextOptionType] else { return }
        
        print("\nCOUNTING VALID OPTIONS.....")
        var validIndices: [Int] = []
        for index in 0..<optionCount {
            let newFoodList = nextFoodList.compactMap({nextOptionType.compareEnumCase($0, choiceIndex: index)})
            print("\(optionCaseNames[nextOptionType]![index]): length of \(newFoodList.count)")
            if !newFoodList.isEmpty {
                validIndices.append(index)              //append valid nextOption that, at least one food is led by the option
            }
        }
        self.nextValidOptionIndices = validIndices
        print("COUNT DONE - Next valid options: \(validIndices)")
    }
    
    func configureNextViewController(viewController: OptionViewController) -> OptionViewController? {
        guard let remainingOptionList = self.remainingOptionList else { return nil }
        guard let nextFoodList = self.nextFoodList else { return nil }
        guard let nextOptionType = self.nextOptionType else { return nil }
        guard let nextValidOptionIndices = self.nextValidOptionIndices else { return nil}
        viewController.remainingOptionList = remainingOptionList
        viewController.foodList = nextFoodList
        viewController.optionType = nextOptionType
        viewController.validOptionIndices = nextValidOptionIndices
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        return viewController
    }
    
    func loadNextOptionViewController() {
        guard let nextValidOptionIndices = self.nextValidOptionIndices else { return }
        let nextOptionCount: Int = nextValidOptionIndices.count
        switch nextOptionCount {
        case 2:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "TwoOptionsViewController") as? TwoOptionsViewController else { return }
            guard let viewController = self.configureNextViewController(viewController: initViewController) as? TwoOptionsViewController else { return }
            self.present(viewController, animated: true)
        case 3:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "ThreeOptionsViewController") as? ThreeOptionsViewController else { return }
            guard let viewController = self.configureNextViewController(viewController: initViewController) as? ThreeOptionsViewController else { return }
            self.present(viewController, animated: true)
        case 4:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "FourOptionsViewController") as? FourOptionsViewController else { return }
            guard let viewController = self.configureNextViewController(viewController: initViewController) as? FourOptionsViewController else { return }
            self.present(viewController, animated: true)
        case 5:
            guard let initViewController = self.storyboard?.instantiateViewController(withIdentifier: "FiveOptionsViewController") as? FiveOptionsViewController else { return }
            guard let vieWController = self.configureNextViewController(viewController: initViewController) as? FiveOptionsViewController else { return }
            self.present(vieWController, animated: true)
        default:
            break
        }
    }
    
    func loadLoadingViewController() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController else { return }
        viewController.isRandom = false
        viewController.foodList = self.nextFoodList
        viewController.modalPresentationStyle = .fullScreen
        self.configureTransition()
        self.present(viewController, animated: false)
    }
    
    func handleOptionTap(optionIndex: Int) {
        guard let optionType = self.optionType else { return }
        guard let validOptionIndices = self.validOptionIndices else { return }
        guard let newFoodList = self.foodList?.compactMap({
            optionType.compareEnumCase($0, choiceIndex: validOptionIndices[optionIndex])
        }) else { return }
        self.nextFoodList = newFoodList
        
        print("next food list total length: \(newFoodList.count)")
        
        repeat {
            self.pickOptionType(optionIndex: optionIndex)   //randomly-pick next option type, leading to a new remainingOptionList
            self.countValidOptions() //count valid options based on next option type and create validOptionIndices array containing valid option indices
            print("COUNT DONE - Next remainig option types: \(self.remainingOptionList!)\n")
        } while self.nextValidOptionIndices!.isEmpty && !self.remainingOptionList!.isEmpty
        
        self.checkIfLast()
        if !self.isLast {
            self.loadNextOptionViewController()     //based on valid option count, determine next view controller with corresponding ID
        } else {
            self.loadLoadingViewController()
        }
    }
}
