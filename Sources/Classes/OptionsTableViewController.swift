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
    
    internal var currentOption: ToolbarOption?
    
    internal var currentVC: UIViewController?
    
    private let kTableViewReusefulIdentifier = "ViewModeOptionsCell"
    
    private let toolbarSettingCellHeight: CGFloat = 50
    
    private let tintColor: UIColor
    
    weak var delegate: ToolbarOptionsControllerDelegate?
    
    init(options: [ToolbarOption], currentVC: UIViewController, selectedOption: ToolbarOption?, iconTintColor: UIColor = UIButton(type: .system).tintColor) {
        self.currentOption = selectedOption
        self.options = options
        self.currentVC = currentVC
        self.tintColor = iconTintColor
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
    
    @objc func dismissVC(_ sender: Any){
    }
}

extension OptionsTableViewController: UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = options[indexPath.row]
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            if let currentOption = self.currentOption, selected.name == currentOption.name{
                self.delegate?.optionsViewController(self.parent as! EZOptionsViewController, didTapOnSelected: selected)
            }else{
                self.delegate?.optionsViewController(self.parent as! EZOptionsViewController, didSelectedNewOption: selected)
            }
        }
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
        
        cell.configureCellWith(option: options[indexPath.row], currentOption: currentOption, tintColor: tintColor)
        
        return cell
    }
}


