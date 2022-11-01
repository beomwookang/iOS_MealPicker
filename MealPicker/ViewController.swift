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
    var foodList: [FoodDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let path = Bundle.main.path(forResource: "FoodList", ofType: "csv")!
        parseCSVAt(url: URL(fileURLWithPath: path))
    }
}
