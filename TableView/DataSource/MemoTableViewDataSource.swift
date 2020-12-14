//
//  MemoTableViewDataSource.swift
//  TableView
//
//  Created by 김태훈 on 2020/12/14.
//

import UIKit

class MemoTableViewDataSource: NSObject, UITableViewDataSource {
    
    var memo: [MemoClass]  {
        didSet {
            memo.sort()
        }
    }
    var sections: [String]
    var temp: MemoClass = MemoClass.init(year: "", month: "", day: "", hour: "", min: "", sec: "")
    
    func uploadDate() {
        let tempTime = Time.init()
        temp = MemoClass.init(year: tempTime.year, month: tempTime.month, day: tempTime.day, hour: tempTime.hour, min: tempTime.min, sec: tempTime.sec)
    }
    
    init(memo:[MemoClass],sections:[String]) {
        self.memo = memo
        self.sections = sections
    }
    
    func setMemo(memo:[MemoClass]) {
        self.memo = memo
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        switch section {
        case 0:
            title = memo.filter { $0.isPined == true }.count == 0 ? nil : "고정된 메모"
            return title
        default:
            title = memo.filter { $0.isPined == false }.count == 0 ? nil : " "
            let fixtitle = memo.filter { $0.isPined == true }.count == 0 ? nil : "고정된 메모"
            if fixtitle == nil {
                return nil
            } else {
                return title
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let pinedPoint = memo.filter { $0.isPined }.count
        if section == 0 {
            return pinedPoint
        } else {
            return memo.count - pinedPoint
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        let filteredMemo = indexPath.section == 0 ? memo.filter { $0.isPined } : memo.filter { !$0.isPined }
        
        cell.selectionStyle = .blue
        if filteredMemo[indexPath.row].able == true {
            cell.finishSwitch.isOn = true
        } else {
            cell.finishSwitch.isOn = false
        }
        cell.finishSwitch.tag = memo.firstIndex(of: filteredMemo[indexPath.row]) ?? 0
        cell.finishSwitch.addTarget(self, action: #selector(swtichSelected(_:)), for: .valueChanged)
        uploadDate()
        if temp.compare - filteredMemo[indexPath.row].compare == 0 {
            cell.timeLabel.text = "\(filteredMemo[indexPath.row].hour)시 \(memo[indexPath.row].min)분 \(memo[indexPath.row].sec)초"
        } else {
            cell.timeLabel.text = "\(filteredMemo[indexPath.row].year)년 \(memo[indexPath.row].month)월 \(memo[indexPath.row].day)일"
        }
        cell.addtionLabel.text = filteredMemo[indexPath.row].subTitle
        cell.timeLabel.sizeToFit()
        cell.titleLabel.text = filteredMemo[indexPath.row].title
        
        return cell
    }
    
    @objc func swtichSelected(_ sender: UISwitch) {
        if sender.isOn {
            memo[sender.tag].able = true
        } else {
            memo[sender.tag].able = false
        }
    }
    
}
