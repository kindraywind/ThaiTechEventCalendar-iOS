//
//  EventDetailViewController.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    @IBOutlet weak var detailTableView: UITableView!
    var event: Event! //やばい

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = event.title

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return event.links.count
        default:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
             return event.title
        case 1:
            return "Links"
        case 2:
            return "Details"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureSectionDateCell(tableView, indexPath)
        case 1:
            return configureSectionLinkCell(tableView, indexPath)
        case 2:
            return configureSectionSummaryCell(tableView, indexPath)
        default:
            return configureSectionSummaryCell(tableView, indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 ,
            indexPath.row == 2,
            let location = event.location,
            let url = URL(string: location.url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        if indexPath.section == 1,
            let url = URL(string: event.links[indexPath.row].url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    // MARK: - Cell configures (Will be moved to proper place.)

    private func configureSectionDateCell(_ tableView: UITableView, _ indexPath: IndexPath) -> DetailTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.detailLabel.text = DateUtils.dateString(fromDate: event.start, toDate: event.end)
            cell.iconImageView.image = UIImage(named: "calendar")
        case 1:
            cell.detailLabel.text = event.time
            cell.iconImageView.image = UIImage(named: "clock")
            if event.time.isEmpty { cell.isHidden = true }
        case 2:
            if let location = event.location {
                cell.detailLabel.text = location.title
                cell.tag = 1
                cell.detailLabel.textColor = UIColor.TTOrange()
                cell.iconImageView.image = UIImage(named: "map-pin")
            }
        default:
            cell.detailLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        }
        return cell
    }

    private func configureSectionLinkCell(_  tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath)
        let link = event.links[indexPath.row]
        let orangeAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.TTOrange(),
            .font: UIFont.systemFont(ofSize: 17.0)
        ]
        let title = NSAttributedString(string: link.title, attributes: orangeAttributes)

        let plainAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.systemFont(ofSize: 17.0)
        ]
        let type = NSAttributedString(string: " (\(link.type))", attributes: plainAttributes)
        let price = NSAttributedString(string: " \(link.price)", attributes: plainAttributes)

        let linkAttributedString = NSMutableAttributedString()
        linkAttributedString.append(title)
        linkAttributedString.append(type)
        linkAttributedString.append(price)

        cell.textLabel?.attributedText = linkAttributedString
        return cell
    }

    private func configureSectionSummaryCell(_  tableView: UITableView, _ indexPath: IndexPath) -> SummaryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! SummaryTableViewCell

        cell.summaryLabel?.text = event.summary
        if event.summary.isEmpty {
            cell.summaryLabel.isHidden = true
            cell.grayView.isHidden = true
        }

        cell.descLabel.text = event.desc
        return cell
    }
}
