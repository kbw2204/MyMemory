//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by 강병우 on 2017. 12. 24..
//  Copyright © 2017년 강병우. All rights reserved.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var subject: String!
    @IBOutlet var contents: UITextView!
    @IBOutlet var preview: UIImageView!
    override func viewDidLoad() {
        self.contents.delegate = self // 컨텐츠는 텍스트뷰임!
        // 배경 이미지 설정
        let bgImage = UIImage(named: "memo-background")
        self.view.backgroundColor = UIColor(patternImage: bgImage!)
        // 텍스트 뷰의 기본 속성
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor // 오호 이렇게 지울 수 있네?
        self.contents.backgroundColor = UIColor.clear // 텍스트뷰의 백그라운드 칼라 색을 없앰
        // 줄맞춤이 필요하네. 모르는게 너무 많이 나왔는데?? , 여기 줄맞춤 잘 안됨 안맞음
        let style = NSMutableParagraphStyle() // 이게 머지
        style.lineSpacing = 8
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [NSAttributedStringKey.paragraphStyle: style])
        self.contents.text = ""
    }
    // 한번 터치했을 때 네비게이션 바 숨김 이벤트
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        let ts = TimeInterval(0.3) // 시간간격?
        UIView.animate(withDuration: ts){ // 갑자기 사라지면 이상하니깐 애니메이션 효과 줌, 근데 텍스트뷰 클릭하면 안사라짐
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
    //저장버튼을 눌렀을 때 메소드
    @IBAction func save(_ sender: Any) {
        //내용을 입력하지 않았을 경우, 경고, guard ? 이게 뭐지 가드네 ㅋㅋ 반대되는 조건을 적고 이부분만 막고 아니면 else문 처리
        guard self.contents.text?.isEmpty == false else {
            let alertV = UIViewController() // 컨트롤러까지 필요있나??
            let iconImage = UIImage(named: "warning-icon-60")
            alertV.view = UIImageView(image: iconImage)
            alertV.preferredContentSize = iconImage?.size ?? CGSize.zero // 이게 뭐엿지
            let alert = UIAlertController(title: nil,
                                          message: "내용을 입력해주세요",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.setValue(alertV, forKey: "contentViewController") // 빈 공간에 추가할려면 이거 해줘야함
            self.present(alert, animated: true)
            return
        }
        // MemoData 객체를 생성하고, 데이터를 담는다.
        let data = MemoData()
        
        data.title = self.subject // 제목
        data.contents = self.contents.text // 내용
        data.image = self.preview.image // 이미지
        data.regdate = Date() // 작성 시각
        
        // 앱 델리게이트 객체를 읽어온 다음, memolist 배열에 MemoData 객체를 추가한다.
        // 여기 잘 이해안됨
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memolist.append(data)
        
        // 작성폼 화면을 종료하고, 이전 화면으로 되돌아감
        _ = self.navigationController?.popViewController(animated: true)
    }
    //사진버튼을 눌렀을 때 메소드
    @IBAction func pick(_ sender: Any) {
        // 이미지 피커 인스턴스를 생성한다.
        let picker = UIImagePickerController()
        picker.delegate = self
        // 이미지 편집 여부
        picker.allowsEditing = true
        // 이미지 피커 화면을 표시한다.
        self.present(picker, animated: false)
    }
    //아직안함
    func presentPicker(source: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) == true else {
            let alert = UIAlertController(title: "사용할 수 없는 타입입니다", message: nil, preferredStyle: .alert)
            self.present(alert, animated: false)
            return
        }
        
        // 이미지 피커 인스턴스를 생성한다.
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        
        // 이미지 피커 화면을 표시한다.
        self.present(picker, animated: false)
    }
    
    // 이미지 선택을 완료했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //선택된 이미지를 미리보기에 표시한다.
        self.preview.image = info[UIImagePickerControllerEditedImage] as? UIImage
        // 이미지 피커 컨트롤러를 닫음
        picker.dismiss(animated: false)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidChange(_ textView: UITextView) {
        // 내용의 최대 15자리까지 읽어 subject 변수에 저장한다.
        let contents = textView.text as NSString
        let length = ( (contents.length > 15 ) ? 15 : contents.length )
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        // 네비게이션 타이틀에 표시한다.
        self.navigationItem.title = subject
    }
}


