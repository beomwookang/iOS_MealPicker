//
//  OptionViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/01.
//

import UIKit

class OptionViewController: UIViewController {
    
    var remainingOptionList: [OptionType]? {
        didSet {
            if let remainingOptionList = self.remainingOptionList {
                if remainingOptionList.isEmpty {
                    self.isLast = true
                }
            }
        }
    }
    
    var foodList: [FoodDetail]?
    var optionType: OptionType?
    var validOptionIndices: [Int]?
    
    var nextFoodList: [FoodDetail]?
    var nextOptionType: OptionType?
    var nextValidOptionIndices: [Int]?
    
    var isLast: Bool = false
    
    func pickOptionType() {
        guard let optionType = self.optionType else { return }
        switch optionType {
        case .hasMeat:
            self.nextOptionType = .meatType
        case .hasSeafood:
            self.nextOptionType = .seafoodType
        default:
            guard var remainingOptionList = self.remainingOptionList else { return }
            if let index = remainingOptionList.indices.randomElement() {
                let optionType = remainingOptionList.remove(at: index)
                self.nextOptionType = optionType
                self.remainingOptionList = remainingOptionList
            }
        }
    }
    
    func countValidOptions() {
        guard let optionType = self.optionType else { return }
        guard let nextOptionType = self.nextOptionType else { return }
        guard let nextFoodList = self.nextFoodList else { return }
        guard let optionCount = optionCaseCount[optionType] else { return }
        
        var validIndices: [Int] = []
        for index in 0..<optionCount {
            var newFoodList = nextFoodList.compactMap({nextOptionType.compareEnumCase($0, choiceIndex: index)})
            if !newFoodList.isEmpty {
                validIndices.append(index)              //append valid nextOption that, at least one food is led by the option
            }
        }
        self.nextValidOptionIndices = validIndices
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
        switch nextOptionCount{
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
    
    func handleOptionTap(optionIndex: Int) {
        guard let optionType = self.optionType else { return }
        guard let validOptionIndices = self.validOptionIndices else { return }
        guard let newFoodList = self.foodList?.compactMap({
            optionType.compareEnumCase($0, choiceIndex: validOptionIndices[optionIndex])
        }) else { return }
        self.nextFoodList = newFoodList
        
        repeat {
            self.pickOptionType()   //randomly-pick next option type, leading to a new remainingOptionList
            self.countValidOptions() //count valid options based on next option type and create validOptionIndices array containing valid option indices
        } while !self.nextValidOptionIndices!.isEmpty && !self.remainingOptionList!.isEmpty
        
        if !self.isLast {
            self.loadNextOptionViewController()     //based on valid option count, determine next view controller with corresponding ID
        }
    }
}
