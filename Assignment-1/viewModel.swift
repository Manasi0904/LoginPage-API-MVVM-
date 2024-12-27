//
//  viewModel.swift
//  Assignment-1
//
//  Created by Kumari Mansi on 26/12/24.
//
//

import Foundation

class LoginViewModel {
    private let loginAPIURL = "https://restaurant-api.reciproci.com/api/ns/customer/login/v6/verify"
    private let enquiryAPIURL = "https://restaurant-api.reciproci.com/api/ns/enquiry/v2/create"
    
    private let headers = [
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJQSVYrbnZtNHhQRGhLTWhzVVJjKy93PT0iLCJpYXQiOjE3MzUyNzUzNzIsImV4cCI6MTczNTMwNDE3Mn0.VqsfyM1Q8KdUrpJ7Ka35cD2KTtKu1mshUh3nHVj--vI",
        "DEVICE_DETAILS": "59iP9BRSVnfgigx8yftNImqeFG88xvHmHzVjN37uqW0N2xcrE+N07WzU3ubx2c+WCLoIYGAPtcCxG8DZ4KO7fArk6d1WJCmRcJ7GOphPf2rdzVPCR+dvtAefHPoOnYAHdMicU1Pd8RdXx9xwcly8qMbi9k+ILInWSoW9cJl84TtlrX2mxDDYWcs44xz2j7DdEZ4thmzbvpiK1F5E+LAaT4JSUglpjNkyjJYoGnAFrTiRcsudpWDeeKtvDohJcYYUqectip1p0i9j7lbsCKXDCyl26hjZWrJ6RMuofxKUhZXcCMnZLTl2eR5b",
        "CITY": "Belagavi",
        "COUNTRY": "India",
        "Accept-Language": "EN",
        "DEVICE_ID": "AF6D9830-1617-4F8E-AD68-2D0AE5AE94AD",
        "DEVICE_TYPE": "iOS",
        "APP_VERSION": "2.1.8.10",
        "modifiedTime": "1735205030827",
        "Content-Type": "application/json"
    ]

    func verifyLogin( pin: String,  completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        let body = [
            "loginType": "PIN",
            "referenceId": "E7Q6wJz5NQ7CySFpiDtYfWRHfM7PVPC0yr++0J9exBUlAynLnxBx7Kx7sga2Mj+h",
            "pin": pin,
            "deviceToken": "cvEbGwaKw0PDk4IkWWIfix:APA91bFpjpQxP0RXb6pBZS3uaj35V51LEXHX1JQ3t4rBhkOlIveLOav-gLVNyq21wyWOuZ4_HNnRHtR4NjZt3hxSd4_muENrFEct0xsy1pnRaMRnlVXbg0E"
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else { return }
        
        ApiServices.shared.request(
            urlString: loginAPIURL,
            method: "POST",
            headers: headers,
            body: bodyData,
            completion: completion
        )
    }
    
    func submitEnquiry(request: EnquiryRequest, completion: @escaping (Result<EnquiryResponse, NetworkError>) -> Void) {
            let body = [
                "email": request.email,
                "name": request.name,
                "phoneNumber": request.phoneNumber,
                "categoryType": request.categoryType,
                "description": request.description
            ]
        guard let enquerybodyData = try? JSONSerialization.data(withJSONObject: body) else { return }

    
        ApiServices.shared.request(urlString:  enquiryAPIURL, method: "POST", headers: headers, body: enquerybodyData, completion: completion)
        }
}
