//
//  Helpers.swift
//  CountersTests
//
//  Created by Fabio Cezar Salata on 04/07/21.
//

import UIKit

let timeout = 0.1

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func numberOfRows(in tableView: UITableView, section: Int = 0) -> Int? {
    tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}

func cellForRow(in tableView: UITableView, row: Int, section: Int = 0) -> UITableViewCell? {
    tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section))
}

func didSelectRow(in tableView: UITableView, row: Int, section: Int = 0) {
    tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: row, section: section))
}

func givenSession(session: URLSessionSpy, data: Data?, statusCode: Int = 200, error: URLError? = nil) {
    session.data = data
    session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
    session.error = error
}
