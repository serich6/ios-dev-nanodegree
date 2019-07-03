//
//  GetUserDataResponse.swift
//  On The Map
//
//  Created by Sam Rich on 7/2/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//
// example json
//

//{"last_name":"Schowalter","social_accounts":[],"mailing_address":null,"_cohort_keys":[],"signature":null,"_stripe_customer_id":null,"guard":{},"_facebook_id":null,"timezone":null,"site_preferences":null,"occupation":null,"_image":null,"first_name":"Heber","jabber_id":null,"languages":null,"_badges":[],"location":null,"external_service_password":null,"_principals":[],"_enrollments":[],"email":{"address":"heber.schowalter@onthemap.udacity.com","_verified":true,"_verification_code_sent":true},"website_url":null,"external_accounts":[],"bio":null,"coaching_data":null,"tags":[],"_affiliate_profiles":[],"_has_password":true,"email_preferences":null,"_resume":null,"key":"665092666","nickname":"Heber Schowalter","employer_sharing":false,"_memberships":[],"zendesk_id":null,"_registered":false,"linkedin_url":null,"_google_id":null,"_image_url":"https://robohash.org/udacity-665092666"}
import Foundation
struct GetUserDataResponse: Codable {
    let lastName: String
    let socialAccount: Array<String>
    let mailingAddress: String?
    let cohortKeys: Array<String>?
    let signature: String?
    let stripeCustomerId: String?
    let guardValue: Dictionary<String, String>
    let facebookID: String?
    let timezone: String?
    let sitePreferences: String?
    let occupation: String?
    let image: String?
    let firstName: String
    let jabberId: String?
    let languages: String?
    let badges: Array<String>
    let location: String?
    let externalServicePassword: String?
    let principals: Array<String>
    let enrollments: Array<String>
    let email: Email
    let websiteURL: String?
    let externalAccounts: Array<String>
    let bio: String?
    let coachingData: String?
    let tags: Array<String>
    let affiliateProfiles: Array<String>
    let hasPassword : Bool
    let emailPreferences : String?
    let resume : String?
    let key : String
    let nickname : String
    let employerSharing : Bool
    let memberships: Array<String>
    let zendeskId : String?
    let registered : Bool
    let linkedinURL : String?
    let googleId : String?
    let imageURL : String
//
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case socialAccount = "social_accounts"
        case mailingAddress = "mailing_address"
        case cohortKeys = "_cohort_keys"
        case signature = "signature"
        case stripeCustomerId = "_stripe_customer_id"
        case guardValue = "guard"
        case facebookID = "_facebook_id"
        case timezone = "timezone"
        case sitePreferences = "size_preferences"
        case occupation = "occupation"
        case image = "_image"
        case firstName = "first_name"
        case jabberId = "jabber_id"
        case languages = "languages"
        case badges = "_badges"
        case location = "location"
        case externalServicePassword = "external_service_password"
        case principals = "_principals"
        case enrollments = "_enrollments"
        case email = "email"
        case websiteURL = "website_url"
        case externalAccounts = "external_accounts"
        case bio = "bio"
        case coachingData = "coaching_data"
        case tags = "tags"
        case affiliateProfiles = "_affiliate_profiles"
        case hasPassword = "_has_password"
        case emailPreferences = "email_preferences"
        case resume = "_resume"
        case key = "key"
        case nickname = "nickname"
        case employerSharing = "employer_sharing"
        case memberships = "_memberships"
        case zendeskId = "zendesk_id"
        case registered = "_registered"
        case linkedinURL = "linkedin_url"
        case googleId = "_google_id"
        case imageURL = "_image_url"
    }
    
}

//"email":{"address":"heber.schowalter@onthemap.udacity.com","_verified":true,"_verification_code_sent":true}
struct Email: Codable {
    let address: String
    let verified: Bool
    let verificationCodeSent: Bool
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case verified = "_verified"
        case verificationCodeSent = "_verification_code_sent"
    }
}
