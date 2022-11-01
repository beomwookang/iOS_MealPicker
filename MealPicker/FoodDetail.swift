//
//  FoodDetail.swift
//  MealPicker
//
//  Created by Beom Woo Kang on 2022/10/29.
//

import Foundation

struct FoodDetail {
    var name: String
    var country: CountryType
    var isSpicy: SpicyType
    var isHot: Bool
    var isSoup: Bool
    var carbType: CarbType
    var hasMeat: Bool
    var meatType: MeatType
    var hasSeafood: Bool
    var seafoodType: SeafoodType
    init(dataItem: [String]) {
        self.name = dataItem[0]
        self.country = CountryType(rawValue: dataItem[1])!
        self.isSpicy = SpicyType(rawValue: dataItem[2])!
        self.isHot = dataItem[3] == "true" ? true : false
        self.isSoup = dataItem[4] == "true" ? true : false
        self.carbType = CarbType(rawValue: dataItem[5])!
        self.hasMeat = dataItem[6] == "true" ? true : false
        self.meatType = MeatType(rawValue: dataItem[7])!
        self.hasSeafood = dataItem[8] == "true" ? true : false
        self.seafoodType = SeafoodType(rawValue: dataItem[9])!
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
