//
//  postTweet.swift
//  blocks
//
//  Created by Ian Richardson on 8/22/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import Accounts
import Social

class postTweet{

    class func tweetWithPhoto(photo: String, status: String){
        var accountStore = ACAccountStore()
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            if granted {
                var accountsArray = accountStore.accountsWithAccountType(accountType)
                if accountsArray.count > 0 {
                    var twitterAccount = accountsArray[0] as ACAccount
                    
                    let requestAPI = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/update_with_media.json")
                    var appIcon = UIImage(named: photo)
                    var iconData = UIImagePNGRepresentation(appIcon)
                    
                    var parameters = Dictionary<String, AnyObject>()
                    parameters["status"] = status

                    let posts = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestAPI, parameters: parameters)
                    posts.addMultipartData(iconData, withName: "media[]", type: "multipart/png", filename: "Icon")
                    
                    posts.account = twitterAccount
                    
                    let handler: SLRequestHandler =  { (response, urlResponse, error) in
                        println(response)
                        println(urlResponse.statusCode)
                    }
                    
                    posts.performRequestWithHandler(handler)
                }
            }
            else{
                NSNotificationCenter.defaultCenter().postNotificationName("twitterFailed", object: nil)
            }
        }
    }
    
    class func tweet(status: String){
        var accountStore = ACAccountStore()
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            if granted {
                var accountsArray = accountStore.accountsWithAccountType(accountType)
                if accountsArray.count > 0 {
                    var twitterAccount = accountsArray[0] as ACAccount
                    
                    let requestAPI = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/update.json")
                    
                    var parameters = Dictionary<String, AnyObject>()
                    parameters["status"] = status

                    let posts = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestAPI, parameters: parameters)
                    posts.account = twitterAccount
                    
                    let handler: SLRequestHandler =  { (response, urlResponse, error) in
                        println(response)
                        println(urlResponse.statusCode)
                    }
                    
                    posts.performRequestWithHandler(handler)
                }
            }
            else{
                NSNotificationCenter.defaultCenter().postNotificationName("twitterFailed", object: nil)                
            }
        }
    }
}