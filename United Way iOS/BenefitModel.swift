//
//  BenefitModel.swift
//  United Way iOS
//
//  Created by Sharaf Nazaar on 4/14/20.
//  Copyright © 2020 United Way. All rights reserved.
//

import Foundation

struct BenefitModel: Decodable {
    
    let calculators: Calculator
    
    
}

struct Calculator: Decodable {
    let cctc: CCTC
    let childcare: Childcare
    let ctc: CTC
    let eitc: EITC
    let foodstamps: Foodstamps
    let healthcare: Healthcare
    //let high_speed_internet
    //left some benefits
    //let utilities: Utilities
    let welfare: Welfare
    let wic: WIC
}

struct CCTC: Decodable {
    let cctc_amount: Int
    let cctc_benefit_name: String
    let cctc_eligibility: String
//    let city_cctc_amount: Int
//    let federal_cctc_amount: Int
//    let state_cctc_amount: Int
}

struct Childcare: Decodable {
    let childcare_benefit_name: String
    let childcare_copay: Int
    let childcare_eligibility: String
//    let childcare_original_cost: Int
//    let childcare_savings: Int
}

struct CTC: Decodable {
    let ctc_benefit_name: String
    let ctc_eligibility: String
//    let ctc_nonrefundable_portion: Int
//    let ctc_refundable_portion: Int
    let ctc_total: Int
}

struct EITC: Decodable {
    let eitc_amount: Int
    let eitc_benefit_name: String
    let eitc_eligibility: String /////////////
//    let fed_eitc_amount: Int
//    let state_eitc_amount: Int
//    let yctc_amount: Int
}

struct Foodstamps: Decodable {
    let foodstamp_amount: Int
    let foodstamp_benefit_name: String
    let foodstamp_eligibility: String
}

struct Healthcare: Decodable {
    let adult_health_copay: Int
    let adult_health_eligibility: String
    let adult_health_name: String
    let child_health_copay: Int
    let child_health_eligibility: String
    let child_health_name: String
}

//struct Utilities: Decodable {
//
//}

struct Welfare: Decodable {
    let welfare_amount: Int
    let welfare_benefit_name: String
    let welfare_eligibility: String
}

struct WIC: Decodable {
    let wic_amount: Int
    let wic_benefit_name: String
    let wic_eligibility: String
}
