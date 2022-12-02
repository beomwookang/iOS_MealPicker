//
//  InfoViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/12/02.
//

import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func linkAttributionTap(_ sender: UIButton) {
        guard let url = URL(string: "https://beomwookang.notion.site/Image-Assets-Attribution-6fdc23ad2534452ab1553f051b7e4235") else { return }
        UIApplication.shared.open(url)
    }
}
