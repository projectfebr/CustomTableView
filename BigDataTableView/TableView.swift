import UIKit

//MARK: падает на 1_000_000_000_000 ячеек

protocol TableViewDataSource: AnyObject {
    func numberOfRowInTableView(_ tableView: TableView) -> Int
    func tableView(_ tableView: TableView, textForRow row: Int) -> String
}

class TableView: UIScrollView {
    weak var dataSource: TableViewDataSource? {
        didSet {
            print("didSet dataSource")
            print(dataSource?.numberOfRowInTableView(self) ?? "dataSource nil")
            
            guard let rows = dataSource?.numberOfRowInTableView(self) else {return}
    
            for row in 1...rows {
                let cell = TableCell()
                guard let text = dataSource?.tableView(self, textForRow: row) else {break}
                cell.update(text: text)
                cell.backgroundColor = .cyan
                addSubview(cell)
            }
            
            
            contentSize = CGSize(width: bounds.width, height:bounds.height) // (0,0)
            //MARK: не могу на данном этапе получить contentSize и создавать ячейки здесь неправильно
            print(contentSize)
            print(numberOfRow) // определена на данном этапе
            
        }
    }
    
    lazy var numberOfRow = dataSource?.numberOfRowInTableView(self)
    
    var cellArray = [TableCell]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
//        contentSize = CGSize(width: bounds.width, height:bounds.height)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("------ call tableView.layoutSubviews() -------")
        print("Bounds:  \(bounds)")
        print("Frame:   \(frame)")
        
        for (row, cell) in subviews.enumerated() where cell is TableCell {
            cell.frame = CGRect(x: 0, y: CGFloat(0 + row*40), width: bounds.width, height: 40)
            print("Row \(row) \(convert(cell.frame, from: self))") // ?? как отобразить координаты относительно верхней рамки?
        }
        
        contentSize = CGSize(width: bounds.width, height: CGFloat(numberOfRow! * 40))
        print("contentSize: \(contentSize)")

    }

}
