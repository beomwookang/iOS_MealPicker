//
//  FoodDetail.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/10/29.
//

import Foundation

struct FoodDetail {
    var name: String
    var foodID: Int
    var country: CountryType
    var isSpicy: IsSpicy
    var isHot: IsHot
    var isSoup: IsSoup
    var carbType: CarbType
    var hasMeat: HasMeat
    var meatType: MeatType
    var hasSeafood: HasSeafood
    var seafoodType: SeafoodType
    
    init(dataItem: [String]) {
        self.name = dataItem[0]
        self.foodID = Int(dataItem[1])!
        self.country = CountryType(rawValue: Int(dataItem[2])!)!
        self.isSpicy = IsSpicy(rawValue: Int(dataItem[3])!)!
        self.isHot = IsHot(rawValue: Int(dataItem[4])!)!
        self.isSoup = IsSoup(rawValue: Int(dataItem[5])!)!
        self.carbType = CarbType(rawValue: Int(dataItem[6])!)!
        self.hasMeat = HasMeat(rawValue: Int(dataItem[7])!)!
        self.meatType = MeatType(rawValue: Int(dataItem[8])!)!
        self.hasSeafood = HasSeafood(rawValue: Int(dataItem[9])!)!
        self.seafoodType = SeafoodType(rawValue: Int(dataItem[10])!)!
    }
}

protocol PropertyReflectable { }

extension PropertyReflectable {
    subscript(key: String) -> Any? {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if child.label == key { return child.value}
        }
        return nil
    }
}

extension FoodDetail: PropertyReflectable { }

enum CountryType: Int {
    case korean, western, chinese, japanese, others
}

enum IsSpicy: Int {
    case spicy, notSpicy, depends
}

enum IsHot: Int {
    case hot, notHot
}

enum IsSoup: Int {
    case soup, notSoup
}

enum CarbType: Int {
    case rice, noodle, others
}

enum HasMeat: Int {
    case meat, noMeat
}

enum MeatType: Int {
    case pork, beef, chicken, others, NA
}

enum HasSeafood: Int {
    case seafood, noSeafood
}

enum SeafoodType: Int {
    case fish, others, NA
}

enum OptionType: Any {
    case country
    case isSpicy
    case isHot
    case isSoup
    case carbType
    case hasMeat
    case meatType
    case hasSeafood
    case seafoodType
    
    func compareEnumCase(_ foodDetail : FoodDetail, choiceIndex: Int) -> FoodDetail? {
        switch self {
        case .country: return foodDetail.country == CountryType(rawValue: choiceIndex) ? foodDetail : nil
        case .isSpicy: return foodDetail.isSpicy == IsSpicy(rawValue: choiceIndex) ? foodDetail : nil
        case .isHot: return foodDetail.isHot == IsHot(rawValue: choiceIndex) ? foodDetail : nil
        case .isSoup: return foodDetail.isSoup == IsSoup(rawValue: choiceIndex) ? foodDetail : nil
        case .carbType: return foodDetail.carbType == CarbType(rawValue: choiceIndex) ? foodDetail : nil
        case .hasMeat: return foodDetail.hasMeat == HasMeat(rawValue: choiceIndex) ? foodDetail : nil
        case .meatType: return foodDetail.meatType == MeatType(rawValue: choiceIndex) ? foodDetail : nil
        case .hasSeafood: return foodDetail.hasSeafood == HasSeafood(rawValue: choiceIndex) ? foodDetail : nil
        case .seafoodType: return foodDetail.seafoodType == SeafoodType(rawValue: choiceIndex) ? foodDetail : nil
        }
    }
}

let optionCaseCount : [OptionType : Int] = [
    .country: 5,
    .isSpicy: 2,
    .isHot: 2,
    .isSoup: 2,
    .carbType: 3,
    .hasMeat: 2,
    .meatType: 4,
    .hasSeafood: 2,
    .seafoodType: 2
]

let optionCaseNames: [OptionType : [String]] = [
    .country: ["한식", "양식", "중식", "일식", "기타 국가"],
    .isSpicy: ["매운 음식", "안 매운 음식"],
    .isHot: ["따뜻한 음식", "시원한 음식"],
    .isSoup: ["국물 O", "국물 X"],
    .carbType: ["밥", "면", "기타"],
    .hasMeat: ["고기(육류) O", "고기(육류) X"],
    .meatType: ["돼지고기", "소고기", "닭고기", "기타"],
    .hasSeafood: ["해산물 O", "해산물 X"],
    .seafoodType: ["생선(어류)", "기타"]
]

let optionCaseImageNames: [OptionType : [String]] = [
    .country: ["Korean", "Western", "Chinese", "Japanese", "Others"].map({"country_" + $0}),
    .isSpicy: ["Spicy", "NotSpicy"].map({"isSpicy_" + $0}),
    .isHot: ["Hot", "NotHot"].map({"isHot_" + $0}),
    .isSoup: ["Soup", "NotSoup"].map({"isSoup_" + $0}),
    .carbType: ["Rice", "Noodle", "Others"].map({"carbType_" + $0}),
    .hasMeat: ["Meat", "NoMeet"].map({"hasMeat_" + $0}),
    .meatType: ["Pork", "Beef", "Chicken", "Others"].map({"meatType_" + $0}),
    .hasSeafood: ["Seafood", "NoSeafood"].map({"hasSeafood_" + $0}),
    .seafoodType: ["Fish", "Others"].map({"seafoodType_" + $0})
]
