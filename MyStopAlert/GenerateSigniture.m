//   GenerateSigniture.m
//   MyStopMonitor

//   This class is used to generate the signiture needed to get data from
//   the PTV api, it uses the full url as input and breaks that down into
//   a base url, developerID, developer key to generate the signiture that is
//   appended to the url required.  It does this by using the SHA1 encryption
//   methods from the CommonCrypto/CommonHMAC.h library. This was addapted from the
//   PTV API read me document examples.

//   Created by Eddie Power on 7/05/2014.
//   Copyright (c) 2014 Eddie Power.
//   All rights reserved.


#import "GenerateSigniture.h"

@implementation GenerateSigniture

//Method to create a signiture string for url and return full url
-(NSString *) generateURLWithDevIDAndKey: (NSString*)urlPath
{
    //v3/stops/route/{route_id}/route_type/{route_type}
    //MY PTV API detils
    NSString *hardcodedURL = @"http://timetableapi.ptv.vic.gov.au/v3/";
    NSString *hardcodedDevID = @"3000745";
    NSString *hardcodedkey = @"fda7c6c5-2716-42fc-854e-ad0c37f8df97";
    
    //Set the delete range or amount to the length of the hardcoded url string to remove.
    NSRange deleteRange = { 0,[hardcodedURL length] };
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: urlPath];
    deleteRange.length = deleteRange.length - 1;
    //remove range
    [urlString deleteCharactersInRange: deleteRange];

    //check if string has initial query string
    if([urlString hasSuffix:@"?"])
        //then append the other query string seperator
        [urlString appendString:@"&"];
    else
        //otherwise it needs initial seperator
        [urlString appendString:@"?"];
    //
    //now append the developer id in the string.
    [urlString appendFormat:@"devid=%@", hardcodedDevID];
    
    //set the encoding of the characters for encoding/encrypting
    const char *cKey = [hardcodedkey cStringUsingEncoding: NSUTF8StringEncoding];
    const char *cData = [urlString cStringUsingEncoding: NSUTF8StringEncoding];
    
    //run encryption methods from apple library imported
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //create a string pointer
    NSString *hash;
    
    //set mutable string with a length of the encode * 2
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    //for each char in the length of encode string
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        //append a format char
        [output appendFormat:@"%02x", cHMAC[i]];
    
    //set signiture and output and run the query string through
    // the API URL to recieve the signiture
    hash = output;
    NSString* signature = hash;
    NSString *urlSuffix = [NSString stringWithFormat:@"devid=%@&signature=%@", hardcodedDevID,signature];
    NSURL *url = [NSURL URLWithString: urlPath];
    NSString *urlQuery = [url query];
    NSString *stringUrl = @"";
    
    //error check the query result
    if(urlQuery != nil && [urlQuery length] > 0)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&%@",urlPath,urlSuffix]];
        stringUrl = [NSString stringWithFormat:@"%@", url];
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",urlPath,urlSuffix]];
        stringUrl = [NSString stringWithFormat:@"%@", url];
    }

//    NSLog(@"THE URL path IS NOW: %@ AND THE URL SUFFIX IS: %@", urlPath, urlSuffix);
    
    //return signed url for JSON requests.
    return @"http://timetableapi.ptv.vic.gov.au/v3/stops/route/6/route_type/0?direction_id=1&devid=3000745&signature=70A77C568921B0F04A7AC4E58F8C0A82429F9DA9";
}

@end
