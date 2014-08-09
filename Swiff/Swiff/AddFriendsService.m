//
//  AddFriendsService.m
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "AddFriendsService.h"
#import <AddressBook/AddressBook.h>

@implementation AddFriendsService
-(void)syncFriends{
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    comm.delegate = self;
    [comm syncFriends:[[[UIDevice currentDevice]identifierForVendor]UUIDString] forContacts:[self getPhoneContacts]];
}

-(id)init{
    self = [super init];
    if(self){
        self.friends = [[NSMutableArray alloc]init];
        self.friendsStorage = [SWFriendsStorage instance];
    }
    return self;
}

-(void)requestComletedWithData:(NSData*)data{
    NSLog(@"sync friend completed: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    SWFriend* friend = [[SWFriend alloc]init];
    NSArray* objectArray = [JsonSerializer jsonarrayToObjects:data oobjectFatcory:friend];
    for (id object in objectArray) {
        SWFriend* retreivedFriend = (SWFriend*)object;
        [self.friends addObject:retreivedFriend];
    }
    [self addFriendsToStorage];
    [self.delegate friendsSynced];
}
-(void)requestFailedWithError:(NSError*)error{
     NSLog(@"sync friend falied with error: %@", error.description);
}

-(void)addFriendsToStorage{
    for (id object in self.friends) {
        SWFriend* friend = (SWFriend*)object;
        [self.friendsStorage AddorReplaceFriend:friend];
    }
    NSLog(@"count of friends %i", [self.friendsStorage size]);
}

-(NSArray*)getFriends{
    return [self.friendsStorage GetAllFriends];
}

-(NSArray*)getPhoneContacts{
    if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
       ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        NSLog(@"access to phone contacts denied");
    }else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        return [self syncPhoneContacts];
    }else{
        //not determined
        //ask for permission
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                NSLog(@"Just denied");
                return;
            }
            NSLog(@"Just authorized");
        });
    }
    return [self syncPhoneContacts];
}

-(NSArray*)syncPhoneContacts{
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for(int index=0; index < nPeople; index++){
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, index);
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
            
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
            NSString *rawphoneNumber = (__bridge NSString *) phoneNumberRef;
            NSString* phoneNumber = [rawphoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [phoneNumbers addObject:phoneNumber];
            
        }
    }
    return phoneNumbers;
}
@end
