## Table of Contents
- [1. Getting Started](#1-getting-started)
  - [1.1. Users](#users)
    - [User Login](#user-login)
  + [1.2. AWS](#aws)
    - [Upload to S3](#upload-to-s3)
- [2. Contributors](#2-contributors)

# 1. Getting Started

 ![moyodependencies](https://user-images.githubusercontent.com/10519817/135163814-74ab0b99-cbc3-4eef-ae86-35be373a78bf.png)
System Requirements

a. Install Research Kit framework
https://github.com/researchkit/researchkit

b. Install cocoapods 
https://cocoapods.org

c. Install the following pods into your podfile (pod install x)
* pod Alamofire
* pod Keychain Swift
* pod SwiftCharts
* pod SwiftyJSON
* pod iOSDropDown

d. Edit Constants.Swift file with your own URLs and endpoints 


## Users

### User Login

*This route is present for the login of users*

**Path:**

Request Type | URL
--- | ---
 POST |  https://yourLogInURL/loginParticipant

**Params:**

Name | Type | Description
--- | --- | ---
participantID | string | **Required.** User's registered ID.
password | string | **Required.** Password provided must be at least 6 characters long.

**Status Codes:**

Code | Type | Description
---|---|---
200 | Success | Server has processed the request and has successfully updated the user.
401 | Error | Unauthorized. Incorrect username and/or password combination.

**Example Body:**

```
{
  "participantID": your participant ID,
  "password": "yourpassword"
}
```

**Example Response:**

```
{
    "token":"eyJhbGciOiJIUzI1NiIsIc23kpXVCJ9.eyJwYXJ0aWNpcGFudF9pZCI6OTk4ODAwMDAwMCwiY2FwYWNpdHkiOiJjb29yZGluYXRvciIsInN0dWR5IjoidGVzdCIsImV4cCI6MTU2NTg5MTgyMiwiaXNzIjoibG9jYWxob3N0OjgwODAifQ.pMJppHKjUPOp0qF4ErldbHkzjOI8gaG9MEZ-oj_UHyU", 
    "capacity":"coordinator"
}
```

**Example Failure Response:**

```
{
    "error": "json parsing error",
    "error description": "key or value of json is formatted incorrectly"
}
```

## AWS

### Upload to S3

*This route is present for the Amazon S3 file uploads*

**Path:**

Request Type | URL
--- | ---
POST | https://yourUploadURL/upload

**Headers:**

Name | Type | Description
--- | --- | ---
Authorization | string | **Required.** Mars token.
weekMillis | long | **Required.** Timestamp

**Params:**

Name | Type | Description
--- | --- | ---
upload | string | **Required.** Files to be uploaded.

**Status Codes:**

Code | Type | Description
---|---|---
200 | Success | Server has processed the request and has successfully updated the user.
422 | Error | Unprocessable Entry. Specified parameters are invalid.

**Example Header:**

```
Authorization: Mars fdsfsdafeyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZAI6OX0.1YMgT2O8ccKdqvrJph1AcSPeLJpRlVvEgITTXxKWrZY,
"weekMillis": 534118400000
```

**Folder and File Structure:** 

  Folder: yourFolder/studybucket/participantID/timestamp/  
  File: participantID_timestamp_devicePlatform_assessmentName.extension


**Example Response:**

```
{
  "success": "you have completed upload"
}
```
**Privacy Policy:**

The Moyo Health Network provided this application as a Free app. This SERVICE is provided by the Moyo Health Network at no cost and is intended for use as is.

This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.

If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.

The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Moyo Health Network unless otherwise defined in this Privacy Policy.


**Information Collection and Use**

For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to Moyo Health Network collects user entered photos, vital signs and mood survey scores but this information is not tied to any identifiable information. Users are identified internally by a series of randomly generated log in credentials and no information regarding name, date of birth, etc. are collected.

**Log Data**

I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.

**Cookies**

Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.

This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.

**Service Providers**

I may employ third-party companies and individuals due to the following reasons:

*   To facilitate our Service;
*   To provide the Service on our behalf;
*   To perform Service-related services; or
*   To assist us in analyzing how our Service is used.

I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.

**Security**

I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.

**Links to Other Sites**

This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

**Children’s Privacy**

These Services do not address anyone under the age of 18. I do not knowingly collect personally identifiable information from children under 18 years of age. In the case I discover that a child under 18 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions.

**Changes to This Privacy Policy**

I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.

This policy is effective as of 2021-06-22

**Contact Us**

If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at clabdevelopment@gmail.com. All images are unlicense and free to use. 

This privacy policy page was created at [privacypolicytemplate.net](https://privacypolicytemplate.net) and modified/generated by [App Privacy Policy Generator](https://app-privacy-policy-generator.nisrulz.com/)

# 2. Contributors
Whitney Bremer, Corey Shaw, Tony Nguyen, Daniel Phan 
