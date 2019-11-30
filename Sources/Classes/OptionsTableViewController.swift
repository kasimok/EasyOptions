import UIKit

///A table view controller for display of options
class OptionsTableViewController: UIViewController, ToolbarOptionsViewControllerType{
    
    internal var viewHeight: CGFloat {
        get{
            let height = CGFloat(CGFloat(options.count) * toolbarSettingCellHeight)
            if #available(iOS 11.0, *) {
                if let bottomSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                    return bottomSafeArea + 30 + height
                }else{
                    return height + 30
                }
            } else {
                return height + 30
            }
        }
    }
    
    internal var options: [ToolbarOption] = []
    
    internal var selectedIndexPath: IndexPath?
    
    internal var currentVC: UIViewController?
    
    private let kTableViewReusefulIdentifier = "ViewModeOptionsCell"
    
    private let toolbarSettingCellHeight: CGFloat = 50
    
    weak var delegate: ToolbarOptionsControllerDelegate?
    
    init(options: [ToolbarOption], currentVC: UIViewController, selectedOption: ToolbarOption?) {
        self.options = options
        self.currentVC = currentVC
        if let selected = selectedOption,let row = options.firstIndex(where: {$0.name == selected.name}){
            selectedIndexPath = IndexPath(row: row, section: 0)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: view.bounds, style: .plain)
        view.addSubview(tv)
        //Register Cell
        tv.register(UINib(nibName: "OptionsTableViewCell",
                          bundle: Bundle(for: OptionsTableViewCell.self)),
                    forCellReuseIdentifier: kTableViewReusefulIdentifier)
        tv.isScrollEnabled = false
        tv.backgroundColor = UIColor.groupTableViewBackground
        return tv
    }()
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            tableView.frame.size = CGSize.init(width: view.bounds.width,
                                               height: CGFloat(options.count) * toolbarSettingCellHeight + ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!>0 ? (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!+30 : 30))
        } else {
            // Fallback on earlier versions
        }
        view.roundCorners(corners: [.topLeft,.topRight], radius: 15)
    }
    
    override open func loadView() {
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .clear
        
        navigationController?.isNavigationBarHidden = true
        let headerView = OptionHeaderView.instanceFromNib()
        headerView.autoresizingMask = []
        tableView.tableHeaderView = headerView
    }
    
}

extension OptionsTableViewController: UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let touchingNewSelection = (selectedIndexPath != indexPath)
        selectedIndexPath = indexPath
        if #available(iOS 11.0, *) {
            self.tableView.performBatchUpdates({
                tableView.reloadData()
            }) { _ in
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else {return}
                    if touchingNewSelection{
                        self.delegate?.optionsViewController(self, didSelectedNewOption: self.options[indexPath.row])
                    }else{
                        self.delegate?.optionsViewController(self, didTapOnSelected: self.options[indexPath.row])

                    }
                }
            }
        } else {
            self.tableView.beginUpdates()
            tableView.reloadData()
            self.tableView.endUpdates()
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else {return}
                if touchingNewSelection{
                    self.delegate?.optionsViewController(self, didSelectedNewOption: self.options[indexPath.row])
                }else{
                    self.delegate?.optionsViewController(self, didTapOnSelected: self.options[indexPath.row])
                }
            }
        }
        
//        tableView.selectRow(at: <#T##IndexPath?#>, animated: <#T##Bool#>, scrollPosition: <#T##UITableView.ScrollPosition#>)
//        tableView.reloadData()
//        let selected = options[indexPath.row]
//
//        var indexPathsNeedReload: [IndexPath] = []
//
//        if let oldSelectionIndex = options.firstIndex(where: {$0.name == currentOption?.name}) {
//            indexPathsNeedReload.append(IndexPath(row: oldSelectionIndex, section: 0))
//        }
//        currentOption = selected
//        tableView.reloadRows(at: indexPathsNeedReload + [indexPath], with: .none)
//
//        dismiss(animated: true) { [weak self] in
//            guard let self = self else {return}
//            if let currentOption = self.currentOption, selected.name == currentOption.name{
//                self.delegate?.optionsViewController(self, didTapOnSelected: selected)
//            }else{
//                self.delegate?.optionsViewController(self, didSelectedNewOption: selected)
//            }
//        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return toolbarSettingCellHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

extension OptionsTableViewController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewReusefulIdentifier, for: indexPath) as! OptionsTableViewCell
        
        cell.configureCellWith(option: options[indexPath.row])
        cell.accessoryType = (indexPath == selectedIndexPath) ? .checkmark : .none
        return cell
    }
}


