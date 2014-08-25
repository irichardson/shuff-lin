//
//  postFacebook.swift
//  blocks
//
//  Created by Ian Richardson on 8/22/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import Accounts
import Social

class postFacebook{
    
    class func postToFacebook(message: String, appID: String){
        postOnFacebook(message, appID:appID, photo:"", url: "feed")
    }
    
    class func postToFacebookWithImage(message: String, appID: String, photo: String){
        postOnFacebook(message, appID:appID, photo:photo, url: "photos")
    }
    
    class func postOnFacebook(message: String, appID: String, photo: String, url: String){
        var accountStore = ACAccountStore()
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        
        var optionsForPosting = [ACFacebookAppIdKey:appID, ACFacebookPermissionsKey: ["email"], ACFacebookAudienceKey: ACFacebookAudienceFriends]

        accountStore.requestAccessToAccountsWithType(accountType, options: optionsForPosting) {
            granted, error in
            if granted {
                    
                var options = [ACFacebookAppIdKey:appID, ACFacebookPermissionsKey: ["publish_actions"], ACFacebookAudienceKey: ACFacebookAudienceFriends]

                accountStore.requestAccessToAccountsWithType(accountType, options: options) {
                    granted, error in
                    if granted {
                        var accountsArray = accountStore.accountsWithAccountType(accountType)
                        
                            if accountsArray.count > 0 {
                            var facebookAccount = accountsArray[0] as ACAccount
                            
                            var parameters = Dictionary<String, AnyObject>()
                            parameters["access_token"] = facebookAccount.credential.oauthToken
                            parameters["message"] = message
                            
                            var feedURL = NSURL(string: "https://graph.facebook.com/me/\(url)")
                            let posts = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.POST, URL: feedURL, parameters: parameters)
                                
                            if countElements(photo) > 0{
                                var appIcon = UIImage(named: photo)
                                var iconData = UIImagePNGRepresentation(appIcon)
                                posts.addMultipartData(iconData, withName: "picture", type: "image/png", filename: "Icon")
                            }
                
                            let handler: SLRequestHandler =  { (response, urlResponse, error) in
                                println(response.description)
                                println(error)
                                println(urlResponse.statusCode)
                            }
                
                            posts.performRequestWithHandler(handler)
                        }
                    }
                    else{
                        NSNotificationCenter.defaultCenter().postNotificationName("facebookFailed", object: nil)
                        println(error.localizedDescription)
                    }
                }
            }
            else{
                NSNotificationCenter.defaultCenter().postNotificationName("facebookFailed", object: nil)
                println(error.localizedDescription)
            }
        }
    }
    
}