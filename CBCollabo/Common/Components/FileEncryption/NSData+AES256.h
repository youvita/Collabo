//
//  AES256.h
//  AES256
//
//  Created by germonick on 3/30/10.
//  Copyright 2010 Webcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key;


- (NSData *)AES256DecryptWithKey:(NSString *)key;


- (NSData *)AES128EncryptWithKey:(NSString *)key;


- (NSData *)AES128DecryptWithKey:(NSString *)key;


- (NSData*) encryptStringToData:(NSString*)plaintext withKey:(NSString*)key;


- (NSString*) decryptDataToString:(NSData*)ciphertext withKey:(NSString*)key;


- (NSData*) encryptStringToDataAES128:(NSString*)plaintext withKey:(NSString*)key;


- (NSString*) decryptDataToStringAES128:(NSData*)ciphertext withKey:(NSString*)key;


@end
