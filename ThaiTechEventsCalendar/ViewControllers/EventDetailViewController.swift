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
        self.detailTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.detailTableView.estimatedSectionHeaderHeight = 25

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    enum SectionType: Int {
        case date = 0, links, details
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = SectionType(rawValue: section) else {
            return 1
        }

        switch type {
        case .date:
            return 3
        case .links:
            return event.links.count
        case .details:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let type = SectionType(rawValue: section) else {
            return ""
        }

        switch type {
        case .date:
             return event.title
        case .links:
            return "Links"
        case .details:
            return "Details"
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SectionType.date.rawValue {
            let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! EventHeaderTableViewCell
            header.updateUIWith(event)
            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = SectionType(rawValue: indexPath.section) else {
            return configureSectionSummaryCell(tableView, indexPath)
        }

        switch type {
        case .date:
            return configureSectionDateCell(tableView, indexPath)
        case .links:
            return configureSectionLinkCell(tableView, indexPath)
        case .details:
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell else {
            return DetailTableViewCell(style: .default, reuseIdentifier: "detailCell")
        }

        switch indexPath.row {
        case 0:
            cell.detailLabel.text = DateUtils.dateString(fromDate: event.start, toDate: event.end)
            cell.iconImageView.image = UIImage(named: "calendar")
        case 1:
            cell.detailLabel.text = event.time
            cell.iconImageView.image = UIImage(named: "clock")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as? LinkTableViewCell else {
            return LinkTableViewCell(style: .default, reuseIdentifier: "linkCell")
        }

        cell.updateUIWith(event, indexPath)

        return cell
    }

    private func configureSectionSummaryCell(_  tableView: UITableView, _ indexPath: IndexPath) -> SummaryTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as? SummaryTableViewCell else {
            return SummaryTableViewCell(style: .default, reuseIdentifier: "summaryCell")
        }

        cell.updateUIWith(event)

        return cell
    }
}
