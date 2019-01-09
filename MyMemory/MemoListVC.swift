//
//  MemoListVC.swift
//  MyMemory
//
//  Created by 강병우 on 2017. 12. 24..
//  Copyright © 2017년 강병우. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController {
    override func viewDidLoad() {
        if let revealVC = self.revealViewController(){
            // 바 버튼 정의
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu")
            btn.target = revealVC // 버튼 클릭 시 호출할 메소드가 정의된 객체
            btn.action = #selector(revealVC.revealToggle(_:))
            // 정의된 바 버튼 왼쪽에 정의
            self.navigationItem.leftBarButtonItem = btn
            // 제스처 등록
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // 테이블 뷰 갯수를 결정한다네
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //왜 let이지? var이어야 하는거 아닌가?
        let count = self.appDelegate.memolist.count
        return count
    }
    // 개별 행을 어떻게 구성할지 결정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼냄
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 2. 이미지 속성이 비어 있을 경우 "memocell", 아니면 "memoCellWithImage", 음 이미지 유무 비교
        // 근데 왜 변수명을 cellId로 지었을까?
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"

        // 3. 재사용 큐로부터 프로포타입 셀의 인스턴스를 전달받는다.
        //여기서 ! 옵셔널 처리를 안해놈. 이걸 처리해야함.,.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        // 4. memoCell의 내용을 구성한다.
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        //5. Data 타입의 날짜를 yyyy-mm-dd hh:mm:ss 포맷에 맞게 변경한다.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdata.text = formatter.string(from: row.regdate!)
        
        // 6. cell 객체 리턴
        
        return cell
    }
    // viewWillAppear 이란 함수가 원래 있는건가? ㅇㅇ
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 데이터를 다시 읽고, 이에 따라 행을 구성하는 로직이 다시 실행될 것이다.
        // 그냥 다시 이 뷰로 돌아왔을때 최신 데이터를 유지하기 위해서 다시 이 뷰로 올때마다 이 코드가 작동되는 함수네, 원래 있는 함수였고
        self.tableView.reloadData()
    }
    // 테이블의 행을 선택했을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // memolist 배열에서 선택된 행에 맞는 데이터를 꺼낸다.
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 상세 화면의 인스턴스를 생성한다.
        //guard 문 잘 봐야겠네,,
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else{
            return
        }
        // 값을 전달한 다음, 상세 화면으로 이동함
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
