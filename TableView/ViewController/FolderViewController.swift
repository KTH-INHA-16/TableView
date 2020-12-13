//
//  FolderViewController.swift
//  TableView
//
//  Created by 김태훈 on 2020/12/13.
//

import UIKit

class FolderViewController: UIViewController {

    var folderName:String = ""
    var folder: [String:[MemoClass]] = ["기본 파일":[]]
    
    @IBOutlet weak var folderNavBar: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var folderTableView: UITableView!
    @IBAction func makeFolderButton(_ sender: Any) {
        let alert = UIAlertController(title: "새로운 폴더 생성", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let ok = UIAlertAction(title: "확인", style: .default, handler: { _ in
            guard let text = alert.textFields?[0].text else {
                return
            }
            if !text.isEmpty && self.folder[text] == nil{
                self.folder[text] = []
                self.folderTableView.reloadData()
            }
        })
        let no = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(ok)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.hidesBackButton = true
        
        folderNavBar.largeTitleDisplayMode = .automatic
        
        let nibCell = UINib(nibName: "FolderTableViewCell", bundle: nil)
        folderTableView.register(nibCell, forCellReuseIdentifier: "FolderTableViewCell")
        
        let nibHeader = UINib(nibName: "FolderHeaderView", bundle: nil)
        folderTableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "FolderHeaderView")
        
        folderTableView.dataSource = self
        folderTableView.delegate = self
        folderTableView.tableFooterView = UIView()
        
    }

}

extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FolderHeaderView") as! FolderHeaderView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell", for: indexPath) as? FolderTableViewCell else {
            return UITableViewCell()
        }
        let key = Array(folder.keys)[indexPath.row]
        cell.folderTitleLabel.text = key
        cell.folderMemoCountLabel.text = "\(folder[key]!.count)"
        let selectView = UIView()
        selectView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        selectView.alpha = 0.1
        cell.selectedBackgroundView = selectView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Array(folder.keys)[indexPath.row]
        folderName = key
        performSegue(withIdentifier: "unwindToFolder", sender: key)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != 0{
            let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { _, _, _ in
                let key = Array(self.folder.keys)[indexPath.row]
                self.folder.removeValue(forKey: key)
                self.folderTableView.beginUpdates()
                self.folderTableView.deleteRows(at: [indexPath], with: .automatic)
                self.folderTableView.endUpdates()
            })
            deleteAction.image = UIImage(systemName: "trash")
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != 0{
            let changeAction = UIContextualAction(style: .normal, title: nil, handler: { _, _, _ in
                let alert = UIAlertController(title: "폴더명 변경", message: nil, preferredStyle: .alert)
                alert.addTextField()
                let key = Array(self.folder.keys)[indexPath.row]
                let tempMemo = self.folder[key]
                alert.textFields?[0].text = key
                let ok = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    guard let text = alert.textFields?[0].text else {
                        return
                    }
                    if text != key {
                        self.folder.removeValue(forKey: key)
                        self.folder[text] = tempMemo
                        self.folderTableView.reloadData()
                    }
                })
                let no = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                alert.addAction(ok)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            })
            changeAction.image = UIImage(systemName: "pencil")
            changeAction.backgroundColor = .systemIndigo
            
            return UISwipeActionsConfiguration(actions: [changeAction])
        }
        return nil
    }
}
