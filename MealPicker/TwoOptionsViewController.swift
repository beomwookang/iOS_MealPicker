//
//  TwoOptionsViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/01.
//

import UIKit

class TwoOptionsViewController: OptionViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var firstOptionView: UIView!
    @IBOutlet weak var secondOptionView: UIView!
    @IBOutlet weak var noMatterButton: UIButton!
    @IBOutlet weak var timeLimitBar: UIProgressView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressBarView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.checkIfLast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let progress = self.oldProgress {
            self.progressBarView.progress = progress
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateProgress()
    }
    
    override func setTimeLimit() {
        self.timeLimit = 3.0
        self.timeRemainingSeconds = 3.0
    }
    
    override func updateTimeLimitBar() {
        UIView.animate(withDuration: 0.1, animations: {
            self.timeLimitBar.setProgress(self.timeRemainingSeconds/self.timeLimit, animated: true)
        })
    }
    
    override func stopTimer() {
        super.stopTimer()
        self.handleOptionTap(optionIndices: [0, 1])
    }

    override func updateProgress() {
        super.updateProgress()
        guard let newProgress = self.newProgress else { return }
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBarView.setProgress(newProgress, animated: true)
        })
    }
    
    private func configureOptionView(view: UIView, touchHandler: Selector, optionImageName: String, optionLabel: String) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 8, height: 8)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        view.layer.cornerRadius = 20
        
        let subImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: optionImageName)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        let subButton: UIButton = {
            let button = UIButton()
            button.setTitle(optionLabel, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
            button.backgroundColor = .black
            button.layer.opacity = 0.5
            button.layer.cornerRadius = 20
            button.addTarget(self, action: touchHandler, for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        view.addSubview(subImageView)
        view.addSubview(subButton)
        view.bringSubviewToFront(subButton)
        
        NSLayoutConstraint.activate([
            subImageView.topAnchor.constraint(equalTo: view.topAnchor),
            subImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            subButton.topAnchor.constraint(equalTo: view.topAnchor),
            subButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNoMatter() {
        self.noMatterButton.titleLabel?.layer.shadowColor = UIColor.gray.cgColor
        self.noMatterButton.titleLabel?.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.noMatterButton.titleLabel?.layer.shadowRadius = 6
        self.noMatterButton.titleLabel?.layer.shadowOpacity = 0.8
    }
    
    private func configureView() {
        self.navigationItem.hidesBackButton = true
        guard let optionType = self.optionType else { return }
        guard let validOptionIndices = self.validOptionIndices, validOptionIndices.count == 2 else { return }
        guard let optionImageNames = optionCaseImageNames[optionType] else { return }
        guard let optionNames = optionCaseNames[optionType] else { return }

        let firstOptionIndex: Int = validOptionIndices[0]
        let secondOptionIndex: Int = validOptionIndices[1]
        
        self.configureOptionView(view: self.firstOptionView,
                           touchHandler: #selector(firstOptionDidTap),
                           optionImageName: optionImageNames[firstOptionIndex],
                           optionLabel: optionNames[firstOptionIndex])
        self.configureOptionView(view: self.secondOptionView,
                           touchHandler: #selector(secondOptionDidTap),
                           optionImageName: optionImageNames[secondOptionIndex],
                           optionLabel: optionNames[secondOptionIndex])
        self.configureNoMatter()
        self.progressBar.layer.cornerRadius = 3
        self.progressBar.layer.borderColor = UIColor.black.cgColor
        self.progressBar.layer.borderWidth = 2
        self.timeLimitBar.transform = self.timeLimitBar.transform.scaledBy(x: 1, y: 2.5)
    }
    
    @objc func firstOptionDidTap() {
        self.handleOptionTap(optionIndices: [0])
    }
    
    @objc func secondOptionDidTap() {
        self.handleOptionTap(optionIndices: [1])
    }
    
    @IBAction func noMatterButtonTap(_ sender: UIButton) {
        self.handleOptionTap(optionIndices: [0, 1])
    }
}
