//
//  SideBarVC.swift
//  MyMemory
//
//  Created by 강병우 on 2018. 3. 2..
//  Copyright © 2018년 강병우. All rights reserved.
//

import UIKit

class SideBarVC: UITableViewController {
    let uinfo = UserInfoManage() // 개인정보 관리
    let titles = [
        "새 글 작성하기",
        "친구 새글",
        "달력으로 보기",
        "공지사항",
        "통계",
        "계정 관리",
    ]
    let icons = [
        UIImage(named: "icon01"),
        UIImage(named: "icon02"),
        UIImage(named: "icon03"),
        UIImage(named: "icon04"),
        UIImage(named: "icon05"),
        UIImage(named: "icon06"),
    ]
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    var profileImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 사이드 바 맨 위 view 부분
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        headerView.backgroundColor = UIColor.black
        // 테이블 뷰의 헤더 뷰로 지정?
        self.tableView.tableHeaderView = headerView
        //네임 라벨
        self.nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30) // 크기지정 잘 써야ㅏ는데
        self.nameLabel.text = self.uinfo.name ?? "Guest"
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.nameLabel.backgroundColor = UIColor.clear // 텍스트라벨의 배경색도 있엇구나 생각안하고있었네
        headerView.addSubview(nameLabel)
        // 이메일 라벨
        self.emailLabel.frame = CGRect(x: 70, y: 30, width: 200, height: 30)
        self.emailLabel.text = self.uinfo.account ?? "Guest"
        self.emailLabel.textColor = UIColor.white
        self.emailLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.emailLabel.backgroundColor = UIColor.clear
        headerView.addSubview(emailLabel)
        // 프로파일 이미지
        let defaultProfile = self.uinfo.profile
        self.profileImage.image = defaultProfile
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        // 프로필 이미지 둥글게 만들기, 둥글게 처리, 테두리 두께
        self.profileImage.layer.cornerRadius = (self.profileImage.frame.width / 2) // cornerRadius ~ 이미지 둥글게 처리
        self.profileImage.layer.borderWidth = 0 // 테두리 두께 0
        self.profileImage.layer.masksToBounds = true // 마스크효과?, 잘라내기 한 것 반대로 하는건가보네
        
        view.addSubview(self.profileImage)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "menucell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        // 타이틀과 이미지를 대입
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        // 폰트 설정
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //첫번째 줄이 0번째니깐
        if indexPath.row == 0 {
            // 이 부분이 연결을 해준 건가?
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoForm")
            // 타겟은 항상 self 엿던거같은데, 이건 reveal 저 파일에 정의되있는거 따라가는거겟지?
            let target = self.revealViewController().frontViewController as! UINavigationController
            target.pushViewController(uv!, animated: true)
            // 이게 닫는거라고
            self.revealViewController().revealToggle(self)
        } else if indexPath.row == 5 {
            // 여긴 네비게이션 없네?
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "_Profile")
            // 왼 괄호가 나오지
            self.present(uv!, animated: true){
                self.revealViewController().revealToggle(self)
            }
            
        }
    }
   

}
