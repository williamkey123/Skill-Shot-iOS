//
//  LocationTableViewCell.swift
//  Skill Shot
//
//  Created by William Key on 12/21/15.
//
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var gameCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - View Setting Methods

    func setName(_ name: String, withSearchText searchText: String?) {
        guard let validSearchText = searchText else {
            self.locationNameLabel.attributedText = NSAttributedString(string: name)
            return
        }
        let nameString = NSMutableAttributedString(string: name)
        let searchPattern = validSearchText.lowercased()
        let fullRange = NSMakeRange(0, name.count)
        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)

        regex.enumerateMatches(in: name, options: NSRegularExpression.MatchingOptions(), range: fullRange) { textCheckingResult, matchingFlags, stop in
            if let validSubRange = textCheckingResult?.range {
                nameString.addAttribute(.backgroundColor, value: AppDelegate.globalTintColor.withAlphaComponent(0.5), range: validSubRange)
                nameString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: locationNameLabel.font.pointSize), range: validSubRange)
            }
        }
        self.locationNameLabel.attributedText = nameString
    }

    func setGameLabel(forMachines machines: [Machine]?, withSearchText searchText: String?) {
        if var validMachines = machines {
            if validMachines.count <= 0 {
                self.gameCountLabel.attributedText = NSAttributedString(string: "No games")
            } else {
                var machineString = "\(validMachines[0].title.name)"
                if validMachines.count == 2 {
                    machineString = "\(validMachines[0].title.name) and \(validMachines[1].title.name)"
                } else if validMachines.count > 2 {
                    if let validSearchText = searchText {
                        validMachines.sort { machine1, machine2 in
                            switch (machine1.containsString(validSearchText), machine2.containsString(validSearchText)) {
                            case (true, false):
                                return true
                            default:
                                return false
                            }
                        }
                    }
                    let extraCount = validMachines.count - 2
                    machineString = "\(validMachines[0].title.name), \(validMachines[1].title.name), and \(extraCount) more"
                }
                let attributedMachineText = NSMutableAttributedString(string: machineString)
                if let validSearchText = searchText {
                    let searchPattern = validSearchText.lowercased()
                    let fullRange = NSMakeRange(0, machineString.count)
                    let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)

                    regex.enumerateMatches(in: machineString, options: NSRegularExpression.MatchingOptions(), range: fullRange) { textCheckingResult, matchingFlags, stop in
                        if let validSubRange = textCheckingResult?.range {
                            attributedMachineText.addAttribute(.backgroundColor, value: AppDelegate.globalTintColor.withAlphaComponent(0.5), range: validSubRange)
                            attributedMachineText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: gameCountLabel.font.pointSize), range: validSubRange)
                        }
                    }
                }
                self.gameCountLabel.attributedText = attributedMachineText
            }
        } else {
            self.gameCountLabel.attributedText = NSAttributedString(string: "No games")
        }
    }

}
