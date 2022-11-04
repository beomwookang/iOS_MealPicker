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
    var isSpicy: SpicyType
    var isHot: Bool
    var isSoup: Bool
    var carbType: CarbType
    var hasMeat: Bool
    var meatType: MeatType
    var hasSeafood: Bool
    var seafoodType: SeafoodType
    
    init() {
        //기본값은 한국인의 소울 푸드: 김밥 ^ㅇ^
        self.name = "김밥"
        self.foodID = 111
        self.country = .korean
        self.isSpicy = .notSpicy
        self.isHot = false
        self.isSoup = false
        self.carbType = .rice
        self.hasMeat = false
        self.meatType = .noMeat
        self.hasSeafood = false
        self.seafoodType = .noSeafood
    }
    
    init(dataItem: [String]) {
        self.name = dataItem[0]
        self.foodID = Int(dataItem[1])!
        self.country = CountryType(rawValue: dataItem[2])!
        self.isSpicy = SpicyType(rawValue: dataItem[3])!
        self.isHot = dataItem[4] == "true" ? true : false
        self.isSoup = dataItem[5] == "true" ? true : false
        self.carbType = CarbType(rawValue: dataItem[6])!
        self.hasMeat = dataItem[7] == "true" ? true : false
        self.meatType = MeatType(rawValue: dataItem[8])!
        self.hasSeafood = dataItem[9] == "true" ? true : false
        self.seafoodType = SeafoodType(rawValue: dataItem[10])!
    }
}

enum CountryType: String {
    case korean
    case western
    case chinese
    case japanese
    case others
}

enum SpicyType: String {
    case spicy
    case notSpicy
    case depends
}

enum CarbType: String {
    case rice
    case noodle
    case others
}

enum MeatType: String {
    case pork
    case beef
    case chicken
    case others
    case noMeat = "NA"
}

enum SeafoodType: String {
    case fish
    case others
    case noSeafood = "NA"
}

enum OptionType {
    case country
    case isSpicy
    case isHot
    case isSoup
    case carbType
    case hasMeat
    case meatType
    case hasSeafood
    case seafoodType
}
