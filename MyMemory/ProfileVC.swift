//
//  ProfileVC.swift
//  MyMemory
//
//  Created by 강병우 on 2018. 3. 3..
//  Copyright © 2018년 강병우. All rights reserved.
//

import UIKit
// 클래스에 저렇게 옆에 추가하는게 상속인가?
class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 다른 .swift파일을 읽어올 때? ~ 타입 멤버 상수? 선언 ~ let uinfo = UserInfoManager() 이렇게 하면 된다고? 그렇지 swift 파일명() 이렇게 했으니깐?
    // userInfoManage 멤버 상수 선언
    let uinfo = UserInfoManage()
    let profileImage = UIImageView() // 프로필 사진 이미지
    let tv = UITableView() // 프로필 목록, 사진 밑에 목록을 넣을 거니깐?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = "프로필"
        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        //        let image = UIImage(named: "profile-bg")
        let image = self.uinfo.profile
        // 프로필 이미지 놓기
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        // 프로필 둥글게 만들기
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2 // 전에도 이렇게 길었나?
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        // 루트 부에 추가
        self.view.addSubview(self.profileImage)
        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height: 100)
        self.tv.dataSource = self
        self.tv.delegate = self
        self.view.addSubview(self.tv)
        let bg = UIImage(named: "profile-bg")
        let bgImg = UIImageView(image: bg)
        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        
        // 이미지 레이어 설정
        bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        bgImg.layer.borderWidth = 0
        bgImg.layer.masksToBounds = true
        self.view.addSubview(bgImg)
        
        self.view.bringSubview(toFront: self.tv)
        self.view.bringSubview(toFront: self.profileImage)
        self.drawBtn()
        let tap = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true // 이건 뭐지?
    }
    // 피커컨트롤러소스타입?
    func imgPicker(_ source : UIImagePickerControllerSourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source // ?
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker,animated: true)
    }
    @objc func profile(_ sender: UIButton){
        // 로그인 되어있지않으면 로그인창 띄우고 리턴
        guard self.uinfo.account != nil else{
            self.doLogin(self)
            return
        }
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해 주세요", preferredStyle: .actionSheet)
        // 카메라를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default){ (_) in // 이거 잘 써야 겠네..
                self.imgPicker(.camera)
            })
        }
        //앨범
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default){ (_) in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        //포토 라이브러리
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default){ (_) in
                self.imgPicker(.photoLibrary)
            })
        }
        // 취소 버튼
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uinfo.profile = img // 프로필에 이미지(선택한 이미지) 넣어주고,
            self.profileImage.image = img // 프로필 이미지뷰에도 넣어줌
        }
        // 이 구문을 누락하면 이미지 피커 컨트롤러 창은 닫히지 않음
        picker.dismiss(animated: true)
    }
    @objc func doLogin(_ sender: Any){
        // 알람객체? 만들고
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        // (tf) in 이게 뭐지 ㅡㅡ..
        loginAlert.addTextField(){ (tf) in
            tf.placeholder = "Your Account"
        }
        loginAlert.addTextField(){ (tf) in
            tf.placeholder = "PassWord"
            // 처음보는거네
            tf.isSecureTextEntry = true
        }
        // 알람에 버튼 추가~ addAction
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive){ (_) in
            let account = loginAlert.textFields?[0].text ?? "" // 첫번째 필드 : 계정
            let passwd = loginAlert.textFields?[1].text ?? "" // 두번째 필드 : 비번
            if self.uinfo.login(account: account, passwd: passwd){
                // 로그인 성공시
                print("로그인 성공")
                self.tv.reloadData() // 테이블 뷰 갱신? reloadData()가 테이블뷰 cell 갱신이네
                // profileImage ~ 이미지뷰임
                self.profileImage.image = self.uinfo.profile
                
                self.drawBtn()
            } else{
                print("로그인 실패")
                // 메세지에다가 msg를 출력한다고? 먼말이지
                let msg = "로그인에 실패하였습니다."
                let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert,animated: false)
            }
        })
        self.present(loginAlert,animated: false) // compli... 이건 언제 추가하는거야?
    }
    func drawBtn(){
        let v = UIView()
//        v.frame = CGRect(x: 0, y: self.tv.frame.origin.y + self.tv.frame.height, width: self.view.frame.width, height: 40)
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        self.view.addSubview(v)
        // 버튼 정의
        let btn = UIButton(type: .system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2
        btn.center.y = v.frame.size.height / 2
        // 로그인 상태일 때는 로그아웃 버튼을, 로그아웃 상태일땐 로그인
        if self.uinfo.isLogin == true{
            print("로그아웃버튼")
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
        } else{
            print("로그인버튼")
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        }
        // 버튼 등록
        v.addSubview(btn)
        print("버튼")
    }
    // 로그아웃
    @objc func doLogout(_ sender: Any){
        let alert = UIAlertController(title: "LOGOUT", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive){ (_) in
            // 로그아웃 메카니즘, 만약 유저인포메니저의 로그아웃이 됬다면.
            if self.uinfo.logout() {
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile // 로그아웃인데 다시 처리할 필요 있나? 디폴트 이미지로 변경해야 하는것 아닌가
                self.drawBtn()
            }
        })
        self.present(alert, animated: false)
    }
    
    // 이건 오버라ㅣ드 안하네?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    // 이렇게 한쌍? 테이블 뷰 있으면 cell도 있어야지?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)// textlabel어디서난거지
        //detailTextLabel 이건 또 어디서난거야 원래 있는거네, 그 로그인창에 입력 안할때 써잇는것
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = self.uinfo.name ?? "Login please"
        case 1:
            cell.textLabel?.text = "계정"
            cell.detailTextLabel?.text = self.uinfo.account ?? "Login please"
        default:
            ()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.uinfo.isLogin == false {
            // 로그인되어 있지 않는다면 로그인창 고고
            self.doLogin(self.tv) // tv는 뭐야
        } else{
            print("로그인 되있음")
            self.doLogout(self.tv)
        }
    }
    @objc func close(_ sender: Any){
        // 이런 메소드가 어디에 있는지 어캐알아
        self.presentingViewController?.dismiss(animated: true)
    }

}
