//
//  ApiManager.swift
//  assignment
//
//  Created by Chandan on 14/10/18.
//  Copyright © 2018 Chandan. All rights reserved.
//

import Alamofire
import ObjectMapper

typealias Handler<T: Mappable> = ((_ res: CustomRes<T>) -> Void)

class ApiManager {
    static func GET<T: Mappable>(url: String, params: [String: Any]?, handler: @escaping Handler<T>) {
        Alamofire.SessionManager.default.request(url, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil).responseString { res in
            let cr = CustomRes<T>(res: res)
            DispatchQueue.main.async {
                handler(cr)
            }
        }
    }
}

class CustomRes<T: Mappable> {
    var res: DataResponse<String>
    var data: T?

    init(res: DataResponse<String>) {
        self.res = res
        switch res.result {
        case .success:
            if let jsonString = res.result.value {
                print("======OutputJson: \(jsonString)\n\n")
                if let json = T(JSONString: jsonString) {
                    self.data = json
                }
            }
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
}
