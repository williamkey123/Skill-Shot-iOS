//
//  AppInfoViewController.swift
//  Skill Shot
//
//  Created by William Key on 12/31/15.
//
//

import UIKit

class AppInfoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            guard let info = Bundle.main.infoDictionary, let version = info["CFBundleShortVersionString"] as? String,
                let build = info["CFBundleVersion"] as? String else
            {
                return super.tableView(tableView, titleForFooterInSection: section)
            }
            return "Version \(version) (\(build))"
        } else {
            return super.tableView(tableView, titleForFooterInSection: section)
        }
    }

    // MARK: - IBActions

    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func iconsButtonTapped(_ sender: AnyObject) {
        if let webURL = URL(string: "https://icons8.com") {
            UIApplication.shared.open(webURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
        }
    }
    
    @IBAction func alamofireButtonTapped(_ sender: AnyObject) {
        if let webURL = URL(string: "https://github.com/Alamofire/Alamofire") {
            UIApplication.shared.open(webURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
        }
    }
    
    @IBAction func williamKeyButtonTapped(_ sender: AnyObject) {
        if let williamKeyURL = URL(string: "fb://profile/100046690088720") {
            if UIApplication.shared.canOpenURL(williamKeyURL) {
                UIApplication.shared.open(williamKeyURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
            } else if let williamKeyURL = URL(string: "https://www.facebook.com/williamkey123") {
                UIApplication.shared.open(williamKeyURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String : Any]()), completionHandler: nil)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
