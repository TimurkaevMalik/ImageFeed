//
//  ProfilePublicInfo.swift
//  PhotoFlow
//
//  Created by Malik Timurkaev on 01.03.2024.
//

import Foundation

struct Profile {
    var userName: String
    var firstName: String
    var lastName: String?
    var bio: String?
    var name: String {
        firstName + " " + (lastName ?? "")
    }
    
    init(_ result: ProfileResult){
        self.userName = result.userName
        self.firstName = result.firstName
        self.lastName = result.lastName
        self.bio = result.bio
    }
}
