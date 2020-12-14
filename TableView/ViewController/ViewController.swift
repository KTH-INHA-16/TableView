import UIKit

class ViewController: UIViewController {

    var memoDataSource: MemoTableViewDataSource!
    var folderName: String = "기본 파일"
    var sections: [String] = ["고정된 메모",""]
    var folder: [String:[MemoClass]] = [:]
    var memo: [MemoClass] = [MemoClass.init(year: "2000", month: "12", day: "13", hour: "0", min: "0", sec: "00")] {
        didSet {
            memo.sort()
        }
    }
    var temp: MemoClass = MemoClass.init(year: "", month: "", day: "", hour: "", min: "", sec: "")
    var newMemo: MemoClass? {
        willSet {
            guard let ne = newValue else {
                return
            }
            temp = ne
        }
    }
    @IBAction func writeGesture(_ sender: Any) {
        performSegue(withIdentifier: "MemoSegue", sender: nil)
    }
    
    
    @IBOutlet weak var removeNavButton: UIBarButtonItem!
    @IBOutlet weak var navBarDelete: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var sort: UIButton!
    @IBOutlet weak var memoTable: UITableView!
    @IBOutlet weak var underLabel: UILabel!
    @IBAction func firstwriteBtn(_ sender: Any) {
        memoTable.isEditing = false
        //performSegue(withIdentifier: "MemoSegue", sender: nil)
    }
    @IBAction func removeNavButton(_ sender: Any) {
        if memo.count > 0 {
            if memoTable.isEditing == true {
                memoTable.isEditing = false
                navBarDelete.isEnabled = false
                navBarDelete.tintColor = .systemGray6
                removeNavButton.title = "편집"
            } else {
                memoTable.isEditing = true
                navBarDelete.isEnabled = true
                navBarDelete.tintColor = .systemYellow
                removeNavButton.title = "완료"
            }
        }
    }
    
    @IBAction func navBarTrashAction(_ sender: Any) {
        
        if let selectedRows = memoTable.indexPathsForSelectedRows {
            // 1
            var items = [MemoClass]()
            for indexPath in selectedRows  {
                items.append(memo[indexPath.row])
            }
            // 2
            for item in items {
                memo.remove(at: memo.firstIndex(of: item) ?? 0)
            }
            // 3
            memoTable.beginUpdates()
            memoTable.deleteRows(at: selectedRows, with: .automatic)
            memoDataSource.setMemo(memo: memo)
            memoTable.endUpdates()
            memoTable.isEditing = false
            navBarDelete.isEnabled = false
            navBarDelete.tintColor = .systemGray6
            removeNavButton.title = "편집"
        }
        underLabel.text = "\(memo.count)개의 메모"
    }
    
    @IBAction func unwindToFolder(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceView = unwindSegue.source as? FolderViewController else{
            return
        }
        
        folderName = sourceView.folderName
        folder = sourceView.folder
        memo = folder[folderName]!
        memoDataSource.setMemo(memo: memo)
        memoTable.reloadData()
        
        if folderName != "기본 파일" {
            nav.title = folderName
        } else {
            nav.title = "메모"
        }
        
    }
    
    @IBAction func unwindToBack(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceView = unwindSegue.source as? WriteViewController else{
            return
        }
        if sourceView.writeView.text == "" {
            memo.remove(at: sourceView.index)
            memoDataSource.setMemo(memo: memo)
        } else {
            memo[sourceView.index].contents = sourceView.writeView.text
            let strArray = sourceView.writeView.text.components(separatedBy: "\n")
            var change: Bool = false
            var subChange: Bool = false
            for i in strArray {
                if !change && !i.trimmingCharacters(in: .whitespaces).isEmpty {
                    memo[sourceView.index].title = i.trimmingCharacters(in: .whitespaces)
                    change = true
                    continue
                }
                if change && !i.trimmingCharacters(in: .whitespaces).isEmpty{
                    memo[sourceView.index].subTitle = i.trimmingCharacters(in: .whitespaces)
                    subChange = true
                    break
                }
            }
            if !subChange {
                memo[sourceView.index].subTitle = "추가된 내용 없음"
            }
            memo[sourceView.index].font = sourceView.fontSize
        }
        memoDataSource.setMemo(memo: memo)
        memoTable.reloadData()
    }
    
    @IBAction func unwindToTrash(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceView = unwindSegue.source as? WriteViewController else{
            return
        }
        memo.remove(at: sourceView.index)
        memoTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoDataSource = MemoTableViewDataSource(memo: memo, sections: sections)
        nav.largeTitleDisplayMode = .automatic
        self.memoTable.dataSource = memoDataSource
        self.memoTable.delegate = self
        
        memoTable.separatorStyle = .none
        let nibCell = UINib(nibName: "MemoTableViewCell", bundle: nil)
        memoTable.register(nibCell, forCellReuseIdentifier: "MemoTableViewCell")
        
        memoTable.sectionHeaderHeight = CGFloat(20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("c \(folderName)")
        underLabel.text = "\(memo.count)개의 메모"
        let upImage = UIImage(systemName: "arrow.up")
        let downImage = UIImage(systemName: "arrow.down")
        let up = UIAction(title: "최신순", image: upImage, handler: { _ in
            self.memo = self.memo.sorted(by: >)
            self.memoDataSource.setMemo(memo: self.memo)
            self.memoTable.reloadData()
        })
        let down = UIAction(title: "오래된순", image: downImage, handler: { _ in
            self.memo = self.memo.sorted(by: <)
            self.memoDataSource.setMemo(memo: self.memo)
            self.memoTable.reloadData()
        })
        
        sort.menu = UIMenu(title: "정렬", image: nil, identifier: nil, options: .displayInline, children: [down,up])
        sort.showsMenuAsPrimaryAction = true
        navBarDelete.isEnabled = false
        navBarDelete.tintColor = .systemGray6
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        memoTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemoSegue" {
            let vc = segue.destination as? WriteViewController
            if let index = sender as? Int{
                vc?.memo = memo[index]
                vc?.index = index
                if memo[index].able == true {
                    vc?.writeViewEdit = true
                }
                vc?.fontSize = memo[index].font
            } else {
                uploadDate()
                newMemo = temp
                memo.append(temp)
                memoDataSource.setMemo(memo: memo)
                memo = memo.sorted()
                vc?.memo = memo[0]
                vc?.fontSize = memo[0].font
                vc?.index = 0
            }
            memoTable.reloadData()
        } else if segue.identifier == "FolderSegue" {
            let vc = segue.destination as? FolderViewController
            folder[folderName] = memo
            vc?.folderName = folderName
            vc?.folder = folder
        }
    }
    
    func uploadDate() {
        let tempTime = Time.init()
        temp = MemoClass.init(year: tempTime.year, month: tempTime.month, day: tempTime.day, hour: tempTime.hour, min: tempTime.min, sec: tempTime.sec)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let filteredMemo = memo.filter { $0.isPined }
        let nonFilteredMemo = memo.filter { !$0.isPined }
        
        if filteredMemo.count != 0 && section == 0 { return CGFloat(25) }
        else if filteredMemo.count == 0 && section == 0 { return CGFloat(0) }
        if filteredMemo.count != 0 && section == 1 {
            if nonFilteredMemo.count != 0 {
                return CGFloat(3)
            } else {
                return CGFloat(0)
            }
        }
        else if filteredMemo.count == 0 && section == 1 { return CGFloat(0) }
        
        return CGFloat(3)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let pinedPoint = memo.filter { $0.isPined }.count
        if section == 0 {
            return pinedPoint
        } else {
            return memo.count - pinedPoint
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if memoTable.isEditing == false {
            let filteredMemo = indexPath.section == 0 ? memo.filter { $0.isPined } : memo.filter { !$0.isPined }
            
            let alert = UIAlertController.init(title: "비밀번호 입력", message: "비밀 번호를 입력해주시기 바랍니다", preferredStyle: .alert)
            alert.addTextField()
            
            let passwordAlert = UIAlertController.init(title: "비밀번호 불일치", message: "비밀번호가 일치 하지 않습니다", preferredStyle: .alert)
            let passwordOk = UIAlertAction(title: "확인", style: .default, handler: nil)
            passwordAlert.addAction(passwordOk)
            
            if filteredMemo[indexPath.row].lock == true {
                let ask = UIAlertAction(title: "확인", style: .default) { _ in
                    guard let text = alert.textFields?[0].text else {
                        return
                    }
                    if text != filteredMemo[indexPath.row].password {
                        self.present(passwordAlert, animated: true, completion: nil)
                        return
                    } else {
                        self.performSegue(withIdentifier: "MemoSegue", sender: self.memo.firstIndex(of: filteredMemo[indexPath.row]) ?? 0)
                    }
                }
                alert.addAction(ask)
                self.present(alert, animated: true, completion: nil)
            }
            performSegue(withIdentifier: "MemoSegue", sender: self.memo.firstIndex(of: filteredMemo[indexPath.row]) ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let filteredMemo = indexPath.section == 0 ? memo.filter { $0.isPined } : memo.filter { !$0.isPined }
        let target = filteredMemo[indexPath.row]
        
        let action = UIContextualAction(style: .normal,
                                        title: "") { [unowned self]  _, _, _ in
            target.isPined.toggle()
            memoDataSource.setMemo(memo: memo)
            memoTable.reloadData()
        }
        
        action.backgroundColor = .systemYellow
        action.image = target.isPined ? UIImage(systemName: "pin.slash.fill") :
            UIImage(systemName: "pin.fill")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let filteredMemo = indexPath.section == 0 ? memo.filter { $0.isPined } : memo.filter { !$0.isPined }
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.memo.remove(at: self.memo.firstIndex(of: filteredMemo[indexPath.row]) ?? 0)
            self.memoDataSource.setMemo(memo: self.memo)
            self.underLabel.text = "\(self.memo.count)개의 메모"
            self.memoTable.beginUpdates()
            self.memoTable.deleteRows(at: [indexPath], with: .automatic)
            self.memoTable.endUpdates()
            success(true)
            
        })
        deleteAction.image = UIImage(systemName: "trash")
        let lockAction = UIContextualAction(style: .normal, title: "", handler: {_,_,_ in
            if filteredMemo[indexPath.row].lock == false {
                let alert = UIAlertController.init(title: "비밀번호 설정", message: "비밀 번호를 설정해주시기 바랍니다", preferredStyle: .alert)
                alert.addTextField()
                let ask = UIAlertAction(title: "확인", style: .default) { _ in
                    guard let text = alert.textFields?[0].text else {
                        return
                    }
                    if text == "" {
                        let passwordAlert = UIAlertController.init(title: "비밀번호 설정 실패", message: "공백입니다", preferredStyle: .alert)
                        let passwordOk = UIAlertAction(title: "확인", style: .default, handler: nil)
                        passwordAlert.addAction(passwordOk)
                        self.present(passwordAlert, animated: true, completion: nil)
                        return
                    } else {
                        filteredMemo[indexPath.row].lock = true
                        filteredMemo[indexPath.row].password = text
                        self.memoDataSource.setMemo(memo: self.memo)
                    }
                }
                alert.addAction(ask)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController.init(title: "비밀 번호 해제", message: "비밀 번호를 해제 하시겠습니까?", preferredStyle: .alert)
                alert.addTextField()
                let ok = UIAlertAction(title: "확인", style: .default) { _ in
                    guard let text = alert.textFields?[0].text else {
                        return
                    }
                    if text == filteredMemo[indexPath.row].password {
                        filteredMemo[indexPath.row].lock = false
                        filteredMemo[indexPath.row].password = ""
                        self.memoDataSource.setMemo(memo: self.memo)
                        return
                    } else {
                        let passwordAlert = UIAlertController.init(title: "비밀번호 해제 실패", message: "실패", preferredStyle: .alert)
                        let passwordOk = UIAlertAction(title: "확인", style: .default, handler: nil)
                        passwordAlert.addAction(passwordOk)
                        self.present(passwordAlert, animated: true, completion: nil)
                    }
                }
                let no = UIAlertAction(title: "취소", style: .destructive) { _ in }
                alert.addAction(ok)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            }
        })
        lockAction.backgroundColor = UIColor.systemBlue
        lockAction.image = UIImage(systemName: "lock")
        return UISwipeActionsConfiguration(actions:[deleteAction,lockAction])
    }
    
}
