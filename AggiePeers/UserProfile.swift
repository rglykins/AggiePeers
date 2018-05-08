//
//  UserProfile.swift
//  AggiePeers
//
//  Created by Robert Lykins on 4/20/18.
//  Copyright © 2018 Robert Lykins. All rights reserved.
//

import RealmSwift

class UserProfile: Object{
    
    @objc dynamic var userId:String = UUID().uuidString
    @objc dynamic var descript:String = ""
    @objc dynamic var status:String = ""
    @objc dynamic var photo: Data? = nil
    @objc dynamic var name:String = ""
    @objc dynamic var rating:Float = 0.9
    let userClasses = LinkingObjects(fromType: ClassInfo.self, property: "tutors")
    override static func primaryKey() -> String? {
        return "userId"
    }
}



class ClassInfo: Object{
    @objc dynamic var classId:String = UUID().uuidString
    @objc dynamic var className:String = ""
    @objc dynamic var classNum:Int = 0
    let tutors = List<UserProfile>()
    override static func primaryKey() -> String? {
        return "classId"
    }
}

class SubjectInfo: Object{
    @objc dynamic var subjectId:String = UUID().uuidString
    @objc dynamic var subjectName:String=""
    @objc dynamic var initials:String = ""
    let classes = List<ClassInfo>()
    override static func primaryKey() -> String? {
        return "subjectId"
    }
}


class MessageInfo: Object{
    @objc dynamic var id:String = UUID().uuidString
    @objc dynamic var sender:String = UUID().uuidString
    @objc dynamic var date:String = UUID().uuidString
    @objc dynamic var content:String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ChatInfo: Object{
    @objc dynamic var tutorId: String = UUID().uuidString
    @objc dynamic var classId: String = UUID().uuidString
    @objc dynamic var studentId: String = UUID().uuidString
    let messages = List<MessageInfo>()
    override static func primaryKey() -> String? {
        return "tutorId"
    }
}

class RequestInfo: Object{
    @objc dynamic var tutorId: String = UUID().uuidString
    @objc dynamic var classId: String = UUID().uuidString
    @objc dynamic var studentId: String = UUID().uuidString
    @objc dynamic var photo: Data?
    @objc dynamic var descript: String = " "
    @objc dynamic var status:String = " "
}

