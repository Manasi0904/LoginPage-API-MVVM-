//
//  view.swift
//  Assignment-1
//
//  Created by Kumari Mansi on 26/12/24.
//

//


import Foundation
struct LoginRequest: Codable {
    var loginType: String
    var referenceId: String
    var pin: String
    var deviceToken: String
}


struct LoginResponse: Codable {
    var status: String
}

struct EnquiryRequest: Codable {
    let email: String
    let name: String
    let phoneNumber: String
    let categoryType: String
    let description: String
}

struct EnquiryResponse: Codable {
    let status: String
   // var message: String
}
