//
//  UserInfoManager.swift
//  MyMemory
//
//  Created by 강병우 on 2018. 3. 9..
//  Copyright © 2018년 강병우. All rights reserved.
//

import UIKit

struct UserInfoKey{
    // 저장에 필요한 키
    static let loginId = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
}
// 계정 및 사용자 정보를 저장 관리하는 클래스
class UserInfoManage{
    var isLogin: Bool{
        // 로그인 아이디가 0이거나 계정이 비어있다면
        if (self.loginId == 0) || (self.account == nil){
            return false
        } else {
            return true
        }
    }
    // 로그인 메소드, 로그인되면,안되면 bool값 줘야하니깐
    func login(account: String,passwd: String) -> Bool{
        // 계정이 맞으면
        if account.isEqual("kbw2204") && passwd.isEqual("1234"){
            print("로그인됨")
            let ud = UserDefaults.standard
            ud.set(100, forKey: UserInfoKey.loginId)
            ud.set(account, forKey: UserInfoKey.account)
            ud.set("강병우", forKey: UserInfoKey.name)
            ud.synchronize()
            return true
        } else{
            return false
        }
    }
    // 로그아웃 메소드, bool값은 왜 리턴?
    func logout() -> Bool{
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }
    // 연산 프로퍼티 loginId 정의
    var loginId: Int{
        // 읽기를 위한 get
        get{
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId) // 이런식으로 클래스 접근하면 되는구나
        }
        // 쓰기를 위한 set
        set(v){
            // 여기 모르겠음
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.loginId)
            ud.synchronize()
        }
    }
    var account: String?{
        // 반환값, return 있고, 값을 쓸때
        get{
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        // 값을 변경하거나 설정할 때
        set(v){
            //ud ~ userDefault
            let ud = UserDefaults.standard
            // v는 뭐지, 설정된 값인가?
            ud.set(v, forKey: UserInfoKey.account)
            ud.synchronize()
            
        }
    }
    var name: String?{
        get{
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v){
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    // UIImage 는 프로퍼티로 직접 저장할 수 없어서 data값으로? 변환한 다음 저장해야함
    var profile: UIImage?{
        get{
            let ud = UserDefaults.standard
            // 만약 ud.data(~) 값이 있다면 그 값을 잠시 _profile에 넣고 {}문을 실행하라! 옵셔널 바인딩!
            if let _profile = ud.data(forKey: UserInfoKey.profile){
                return UIImage(data: _profile)
            } else{ // 값이 없다면
                return UIImage(named: "account.jpg") // 없다면 기본 이미지로
            }
        }
        set(v){
            // 만약 v에 값이 없지않다면 ~ 있다면
            if v != nil{
                let ud = UserDefaults.standard
                ud.set(UIImagePNGRepresentation(v!), forKey: UserInfoKey.profile)
                ud.synchronize()
            }
        }
    }
}

