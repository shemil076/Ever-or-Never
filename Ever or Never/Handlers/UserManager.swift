//
//  UserManager.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-07.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable, Identifiable, Hashable {
    let id: String
    let dateCreated: Date?
    let email: String?
    let photoURL: String?
    let isPremium: Bool
    let displayName: String
    let dob : Date
    
    
    init(auth: AuthDataResultModel){
        self.id = auth.uid
        self.dateCreated = Date()
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.isPremium = false
        self.displayName = ""
        self.dob = Date()
    }
    
    init(auth: AuthDataResultModel, displayName: String, dob: Date){
        self.id = auth.uid
        self.dateCreated = Date()
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.isPremium = false
        self.displayName = displayName
        self.dob = dob
    }
    
    init(id: String, dateCreated: Date?, email: String?, photoURL: String?, isPremium: Bool, displayName: String, dob: Date){
        self.id = id
        self.dateCreated = dateCreated
        self.email = email
        self.photoURL = photoURL
        self.isPremium = isPremium
        self.displayName = displayName
        self.dob = dob
    }
    
    func togglePremuim() -> DBUser{
        let currentPremiumStatus = isPremium
        return DBUser(id: id, dateCreated: dateCreated, email: email, photoURL: photoURL, isPremium: !currentPremiumStatus, displayName: displayName, dob: dob)
    }
     
    enum CodingKeys:String,  CodingKey {
        case id = "id"
        case dateCreated = "dateCreated"
        case email = "email"
        case photoURL = "photoURL"
        case isPremium = "isPremium"
        case displayName = "displayName"
        case dob = "dob"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.dob = try container.decode(Date.self, forKey: .dob)
    }
    
 
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
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
    

    
    private func userDocument(id: String) -> DocumentReference {
        userCollection.document(id)
    }
    
    func createNewUser(user: DBUser) async throws{
        try userDocument(id: user.id).setData(from: user, merge: true)
    }
    
     

    
    func getUser(id: String) async throws -> DBUser{
        try await userDocument(id: id).getDocument(as: DBUser.self)
    }
    
    
    func updateUserPremiumStatus(id: String, isPremium: Bool) async throws{
        
        let data: [String : Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(id: id).updateData(data)
    }
}
