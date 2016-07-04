//
//  DataService.swift
//  quick-chat
//
//  Created by Luchao Cao on 2016-06-28.
//  Copyright © 2016 Luchao Cao. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()//DATABASE_URL in GoogleService-Info.plist

class DataService {
    // Create a singlton
    static let ds = DataService()
    private var _REF_BASE = URL_BASE
    private var _REF_USERS = URL_BASE.child("users")
    private var _REF_POSTS = URL_BASE.child("posts")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return self._REF_USERS
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return self._REF_POSTS
    }
    
    // If uid doesn't exist, create; if exist, update
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).setValue(user)
    }
}
