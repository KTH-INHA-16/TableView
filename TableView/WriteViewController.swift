import UIKit

class WriteViewController: UIViewController {

    @IBOutlet weak var writeView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var textColorBtn: UIBarButtonItem!
    @IBOutlet weak var navBarBtn: UIBarButtonItem!
    @IBAction func textColor(_ sender: Any) {
    }
    
    var fontSize: CGFloat = CGFloat(10.0)
    var writeViewEdit: Bool = false
    var index: Int = 0
    var memo: MemoClass?
    var newMemo: MemoClass? {
        willSet {
            memo = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nav.largeTitleDisplayMode = .never
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let realMemo = memo else {
            writeView.text = ""
            return
        }
        writeView.text = realMemo.contents
        timeLabel.text = "\(realMemo.year)년 \(realMemo.month)월 \(realMemo.day)일 \(realMemo.hour):\(realMemo.min)"
        scroll.contentOffset = CGPoint(x: 0, y: 10)
        if writeViewEdit == true {
            writeView.isEditable = false
        } else {
            writeView.isEditable = true
        }
        
        self.writeView.font? =  (self.writeView.font?.withSize(fontSize))!
        
        let small = UIAction(title: "작게", image: UIImage(systemName: "pencil"), handler: { _ in
            self.writeView.font? =  (self.writeView.font?.withSize(CGFloat(12.0)))!
            self.fontSize = CGFloat(12.0)
        })
        
        let medium = UIAction(title: "중간", image: UIImage(systemName: "pencil"), handler: { _ in
            self.writeView.font? = (self.writeView.font?.withSize(CGFloat(18.0)))!
            self.fontSize = CGFloat(18.0)
        })
        
        let large = UIAction(title: "크게", image: UIImage(systemName: "pencil"), handler: { _ in
            self.writeView.font? = (self.writeView.font?.withSize(CGFloat(25.0)))!
            self.fontSize = CGFloat(25.0)
        })
        
        textColorBtn.primaryAction = nil
        textColorBtn.menu = UIMenu(title: "문자 크기", image: nil, identifier: nil, options: .displayInline, children: [large,medium,small])
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
}
