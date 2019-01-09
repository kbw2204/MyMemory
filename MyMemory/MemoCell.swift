//
//  MemoCell.swift
//  MyMemory
//
//  Created by 강병우 on 2017. 12. 24..
//  Copyright © 2017년 강병우. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {

    @IBOutlet var subject: UILabel! // 메모  제목
    @IBOutlet var regdata: UILabel! // 메모 작성일자
    @IBOutlet var contents: UILabel! // 메모 내용
    @IBOutlet var img: UIImageView! // 메모 이미지
}
