//
// Created by Dapeng Wang on 3/16/16.
// Copyright (c) 2016 Dapeng Wang. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import AlamofireJsonToObjects
import AlamofireObjectMapper

class HRMSApi {
    
    static let sharedInstance: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        
        return SessionManager(configuration: configuration)
    }()
    
    typealias CompleteHandler = (Parameters?, NSError?, HTTPURLResponse?) -> ()
    
    
    class func getURL(_ relative: String) -> String {
        return API_URL + relative
    }
    
    @discardableResult
    class func GET<T:HRMSModel>(_ url: String, params: Parameters?, completionHandler: ((_ response: T?, _ error:HRMSError?) -> ())?) -> Request  {
        return HRMSApi.sharedInstance.request(getURL(url), parameters: params, encoding: URLEncoding.queryString)
            .responseObject { (response: DataResponse<T>?) in
                self.handleResponse(response, completionHandler: completionHandler )
        }
    }

    @discardableResult
    class func POST<T:HRMSModel>(_ url: String, params: Parameters?, completionHandler: ((_ response: T?, _ error:HRMSError?) -> ())?) -> Request  {
        return Alamofire.request(getURL(url), method:.post, parameters: params, encoding: URLEncoding.queryString)
            .responseObject { (response: DataResponse<T>?) in
                self.handleResponse(response, completionHandler: completionHandler )
        }
    }
    
    @discardableResult
    class func POST<T:HRMSModel>(_ url: String, params: Parameters?, completionHandler: ((_ response: [T]?, _ error:HRMSError?) -> ())?) -> Request  {
        return Alamofire.request(getURL(url), method:.post, parameters: params, encoding: URLEncoding.queryString)
            .responseArray { (response: DataResponse<[T]>?) in
                self.handleArrayResponse(response, completionHandler: completionHandler )
        }
    }
    
    class func handleResponse<T:HRMSModel>(_ response: DataResponse<T>?, completionHandler: ((_ response: T?, _ error:HRMSError?) -> ())?) {
        if let res = response {
            if let value = res.result.value {
                completionHandler?(value, nil);
            } else {
                completionHandler?(nil, HRMSError(message: "没知道信息"))
            }
        } else {
            completionHandler?(nil, nil)
        }
    }
    
    class func handleArrayResponse<T:HRMSModel>(_ response: DataResponse<[T]>?, completionHandler: ((_ response: [T]?, _ error:HRMSError?) -> ())?) {
        if let res = response {
            if let value = res.result.value {
                completionHandler?(value, nil);
            } else {
                completionHandler?(nil, HRMSError(message: "没知道信息"))
            }
        } else {
            completionHandler?(nil, nil)
        }
    }

    fileprivate class func handleFailure(_ error: NSError) {
        //        l.error(error.localizedDescription)
    }

}

