//
//  UserManager.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-07.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable {
    let userId: String
    let dateCreated: Date?
    let email: String?
    let photoURL: String?
    let isPremium: Bool
    let displayName: String
    let dob : Date
    
    
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.dateCreated = Date()
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.isPremium = false
        self.displayName = ""
        self.dob = Date()
    }
    
    init(auth: AuthDataResultModel, displayName: String, dob: Date){
        self.userId = auth.uid
        self.dateCreated = Date()
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.isPremium = false
        self.displayName = displayName
        self.dob = dob
    }
    
    init(userId: String, dateCreated: Date?, email: String?, photoURL: String?, isPremium: Bool, displayName: String, dob: Date){
        self.userId = userId
        self.dateCreated = dateCreated
        self.email = email
        self.photoURL = photoURL
        self.isPremium = isPremium
        self.displayName = displayName
        self.dob = dob
    }
    
    func togglePremuim() -> DBUser{
        let currentPremiumStatus = isPremium
        return DBUser(userId: userId, dateCreated: dateCreated, email: email, photoURL: photoURL, isPremium: !currentPremiumStatus, displayName: displayName, dob: dob)
    }
     
    enum CodingKeys:String,  CodingKey {
        case userId = "user_id"
        case dateCreated = "date_created"
        case email = "email"
        case photoURL = "photo_url"
        case isPremium = "is_premium"
        case displayName = "display_name"
        case dob = "dob"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.dob = try container.decode(Date.self, forKey: .dob)
    }
    
 
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encode(self.isPremium, forKey: .isPremium)
        try container.encode(self.displayName, forKey: .displayName)
        try container.encode(self.dob, forKey: .dob)
    }
    
    
}

final class UserManager {
    
    static let shared = UserManager()
    
    private init() {
        
    }
    
    private let userCollection = Firestore.firestore().collection("users")
    

    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws{
        try userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    
     

    
    func getUser(userId: String) async throws -> DBUser{
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws{
        
        let data: [String : Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
}
