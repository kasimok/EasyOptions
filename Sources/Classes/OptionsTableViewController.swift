import UIKit

///A table view controller for display of options
class OptionsTableViewController: UIViewController, ToolbarOptionsViewControllerType{
    
    internal var viewHeight: CGFloat {
        get{
            if #available(iOS 11.0, *) {
                return CGFloat(CGFloat(options.count) * toolbarSettingCellHeight + ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!>0 ? (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!+30 : 30))
            } else {
                // Fallback on earlier versions
                return 0.0
            }
        }
    }
    
    internal var options: [ToolbarOption] = []
    
    internal var currentOption: ToolbarOption?
    
    internal var currentVC: UIViewController?
        
    private let kTableViewReusefulIdentifier = "ViewModeOptionsCell"
    
    private let toolbarSettingCellHeight: CGFloat = 50
    
    weak var delegate: ToolbarOptionsControllerDelegate?
    
    init(options: [ToolbarOption], currentVC: UIViewController, selectedOption: ToolbarOption?) {
        self.currentOption = selectedOption
        self.options = options
        self.currentVC = currentVC
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
    
    @objc func dismissVC(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
}

extension OptionsTableViewController: UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = options[indexPath.row]
        
        if let currentOption = currentOption, selected.name == currentOption.name{
            delegate?.optionsViewController(self, didTapOnSelected: selected)
        }else{
            delegate?.optionsViewController(self, didSelectedNewOption: selected)
        }
        
        dismissVC(selected)
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
       
        cell.configureCellWith(option: options[indexPath.row], currentOption: currentOption)
        
        return cell
    }
}


