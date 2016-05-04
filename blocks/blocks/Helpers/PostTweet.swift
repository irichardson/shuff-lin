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

class PostTweet{

    class func tweetWithPhoto(photo: String, status: String){
        postToTwitter(photo, status: status, url: "update_with_media.json")
    }
    
    class func tweet(status: String){
        postToTwitter("", status: status, url: "update.json")
    }
    
    class func postToTwitter(photo: String, status: String, url: String){
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            if granted {
                var accountsArray = accountStore.accountsWithAccountType(accountType)
                if accountsArray.count > 0 {
                    let twitterAccount = accountsArray[0] as! ACAccount
                    
                    let requestAPI = NSURL(string:"https://api.twitter.com/1.1/statuses/\(url)")
                    
                    var parameters = Dictionary<String, AnyObject>()
                    parameters["status"] = status

                    let posts = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestAPI, parameters: parameters)
                    
                    if photo.characters.count > 0 {
                        let appIcon = UIImage(named: photo)
                        
                        print(appIcon!.description)
                        
                        let iconData = UIImagePNGRepresentation(appIcon!)
                        posts.addMultipartData(iconData, withName: "media[]", type: "multipart/png", filename: "Icon")
                    }
                    
                    posts.account = twitterAccount
                    
                    let handler: SLRequestHandler =  { (response, urlResponse, error) in
                        print(response.description, terminator: "")
                        print(urlResponse.statusCode, terminator: "")
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