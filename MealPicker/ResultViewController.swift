//
//  ResultViewController.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/11/04.
//

import UIKit
import Lottie
import CoreLocation

class ResultViewController: UIViewController, CLLocationManagerDelegate {
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
    var alertController: UIAlertController?
    
    var foodList: [FoodDetail]?
    var foodResult: FoodDetail?
    
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.pickFromList()
        self.configureView()
        guard let foodList = self.foodList else { return }
        if foodList.isEmpty {
            self.rerollButton.isHidden = true
        } else {
            self.rerollButton.isHidden = false
        }
        self.showLottieAnimation("result_pop", .scaleAspectFill, 1.5)
        self.configureAlert()
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
    
    private func configureAlert() {
        self.alertController = UIAlertController(title: "위치정보 이용 동의", message: "[설정 - 개인정보 보호 - 위치 서비스]에서\n 앱 위치 접근 권한을 설정해주세요:)", preferredStyle: .alert)
        self.alertController?.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    }
    
    private func configureLabel(foodName: String) {
        self.resultLabel.text = foodName
        self.resultLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
    }

    private func configureView() {
        guard let foodResult = self.foodResult else { return }
        self.resultLabel.text = foodResult.name
        self.resultLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        //self.resultImageView.image = UIImage(name: "fid@\(foodResult.foodID)") ?? UIImage(systemName: "xmark")?.withTintColor(.black)
        //self.resultImageView.image = UIImage(systemName: "xmark")?.withTintColor(.black)        //temporary image
        if let resultImage = UIImage(named: foodResult.name) {
            self.resultImageView.image = resultImage
        } else {
            self.resultImageView.image = UIImage(named: "NoImage")
        }
    }
    
    private func updateResultImage(foodID: Int) {
        guard let foodResult = self.foodResult else { return }
        UIView.transition(with: self.resultImageView!,
                          duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
            if let resultImage = UIImage(named: foodResult.name) {
                self.resultImageView.image = resultImage
            } else {
                self.resultImageView.image = UIImage(named: "NoImage")
            }
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

    @IBAction func openMapButton(_ sender: UIButton) {
        if self.locationManager.authorizationStatus == .authorizedAlways || self.locationManager.authorizationStatus == .authorizedWhenInUse {
            guard let latitude = self.latitude else { return }
            guard let longitude = self.longitude else { return }
            guard let resultFoodName = self.resultLabel?.text else { return }
            if let encodedString = "kakaomap://search?q=\(resultFoodName)&p=\(latitude),\(longitude)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let url = URL(string: encodedString)
                let appStoreURL = URL(string: "https://itunes.apple.com/app/id304608425?mt=8")!
                if UIApplication.shared.canOpenURL(URL(string: "kakaomap://")!) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(appStoreURL)
                }
            }
        } else {
            guard let alertController = self.alertController else { return }
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func openNMapButton(_ sender: UIButton) {
        if self.locationManager.authorizationStatus == .authorizedAlways || self.locationManager.authorizationStatus == .authorizedWhenInUse {
            guard let resultFoodName = self.resultLabel?.text else { return }
            if let encodedString = "nmap://search?query=\(resultFoodName)&appname=com.bammoothe.MealPicker"
.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let url = URL(string: encodedString)
                let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
                if UIApplication.shared.canOpenURL(URL(string: "nmap://")!) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(appStoreURL)
                }
            }
        } else {
            guard let alertController = self.alertController else { return }
            self.present(alertController, animated: true)
        }
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

extension ResultViewController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        case .denied:
            print("GPS 권한 요청 거부됨")
            self.locationManager.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
        
    // 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
