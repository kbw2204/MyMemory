//
//  CSLogButton.swift
//  MyMemory
//
//  Created by 강병우 on 2018. 2. 15..
//  Copyright © 2018년 강병우. All rights reserved.
//

import UIKit

public enum CSLogType: Int{
    case basic // 기본 로그 타입? 이게 머임
    case title // 버튼의 타이틀을 출력
    case tag // 버튼의 태그값을 출력
}
public class CSLogButton: UIButton {
    // 프로퍼티 추가, 프로퍼티란 이름과 값 사이 연결 의미를 뜻함
    public var logType: CSLogType = .basic
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) // aDecoder가 뭐지
        self.setBackgroundImage(UIImage(named: "button-bg"), for: .normal)
        self.tintColor = UIColor.white // tintcolor는 뭐지 버튼색상??
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
        

    }
    @objc func logging(_ sender: UIButton){
        switch self.logType {
        case .basic:
            NSLog("버튼이 클릭되었습니다.")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "타이틀 없는" // titleLabel을 옵셔널 처리를 해줬는데, 만약 값이 있다면 앞에있는 옵셔널 처리해준 titleLabel값을 쓰고, 만약 nil, 값이 없다면 ?? 뒤에있는 값을 사용함. 즉 타이틀 없는 값을 사용하게 되는것!
            NSLog("\(btnTitle) 버튼이 클릭되었습니다.")
        case .tag:
            NSLog("\(sender.tag) 버튼이 클릭되었습니다.")
        }// 여기에 default가 들어갔다고 안됬엇네;; 왜그러지
    }
    }


