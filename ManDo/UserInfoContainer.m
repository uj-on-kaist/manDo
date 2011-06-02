//
//  UserInfoContainer.m
//  ManDo
//
//  Created by 정의준 on 11. 6. 1..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "UserInfoContainer.h"

#import "ASIFormDataRequest.h"

#import "NSDictionary_JSONExtensions.h"

@implementation UserInfoContainer

@synthesize phone,name,age,gender,type,majorIn;

@synthesize imageURL;

static UserInfoContainer *sharedInfo = NULL;

+ (UserInfoContainer *)sharedInfo{
    @synchronized(self) {
        if (sharedInfo == NULL)
            sharedInfo = [[self alloc] init];
    }   
    return(sharedInfo);
}


-(BOOL)isMale{

    if([gender isEqualToString:@"M"]){
        return YES;
    }
    return NO;
}


#define USER_COL 0
#define GIRL_COL 1
#define NAME_COL 2


-(NSString *)getGirlName:(NSString *)phoneNumber{
    NSMutableArray *array=[[UserInfoContainer sharedInfo] getMyList];
    
    NSString *result=@"";
    
    for(int i=0;i<[array count]; i++){
        NSMutableDictionary *cell_item = [array objectAtIndex:i];
        if([[cell_item objectForKey:@"girl"] isEqualToString:phoneNumber]){
            int g_type=[[cell_item objectForKey:@"type"] intValue];
            int g_order=[[cell_item objectForKey:@"g_order"] intValue];
            
            NSString *typedStr=@"미지의";
            switch (g_type) {
                case 1:
                    typedStr=@"도도한";
                    break;
                case 2:
                    typedStr=@"섹시한";
                    break;
                case 3:
                    typedStr=@"귀여운";
                    break;
                default:
                    break;
            }
            
            result=[NSString stringWithFormat:@"%@ %d호",typedStr,g_order];
            
            return result;
        }
    }
    
    return result;
}


-(void)check_insert:(NSString *)phoneNumber{
    NSLog(@"Check %@  START", phoneNumber);
    NSMutableArray *array=[[UserInfoContainer sharedInfo] getMyList];

    for(int i=0;i<[array count]; i++){
        NSMutableDictionary *cell_item = [array objectAtIndex:i];
        if([[cell_item objectForKey:@"girl"] isEqualToString:phoneNumber]){
            return;
        }
    }
    NSLog(@"NOT %@, INSERT START", phoneNumber);
    [self addGirl:phoneNumber];
}

-(NSMutableArray *)getMyList{
    if([sharedInfo.phone isEqualToString:@""] || sharedInfo.phone == nil || [sharedInfo.gender isEqualToString:@"F"]){
        return nil;
    }
    
    // Get the path to the main bundle resource directory.

    NSString *pathsToReources = [[NSBundle mainBundle] resourcePath];
    
    NSString *yourOriginalDatabasePath = [pathsToReources stringByAppendingPathComponent:@"USER_GIRLS.sqlite"];
    
    // Create the path to the database in the Documents directory.
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"USER_GIRLS.sqlite"];
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:NULL] != YES)
            
            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath, yourNewDatabasePath);
        
    }
    
    
    NSMutableArray *resultArr=[[NSMutableArray alloc] init];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths objectAtIndex:0];
    
    const char *path = [[documentsDirectory2 stringByAppendingPathComponent:@"USER_GIRLS.sqlite"] UTF8String];

    //NSLog(@"%@",[documentsDirectory2 stringByAppendingPathComponent:@"USER_GIRLS.sqlite"]);
    
    if(sqlite3_open(path, &db) == SQLITE_OK) {
        NSString *queryNS=[NSString stringWithFormat:@"SELECT * FROM USER_GIRL WHERE user = '%@'",sharedInfo.phone];
        //NSLog(@"QUERY: %@",queryNS);
        const char *query = [queryNS UTF8String];
        sqlite3_stmt *statement;

        if (sqlite3_prepare_v2(db, query, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                
                [dict setObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)] 
                         forKey:@"girl"];
                [dict setObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)] 
                         forKey:@"type"];
                [dict setObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)] 
                         forKey:@"g_order"];
                //NSLog(@"dict : %@",dict);
                [resultArr addObject:dict];
            }
        }else{
            NSLog(@"Error open %@",sqlite3_errmsg(db));
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(db);
        db = NULL;
        
        NSLog(@"DB OPEN ERROR: '%s'", sqlite3_errmsg(db));    
    }
    
    
    //NSLog(@"%@",resultArr);
    return resultArr;
}

-(void)addGirl:(NSString *)phoneNumber{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_USER_URL,phoneNumber]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                return;
            }else{                
                //TODO: Succes -> Set to UserInfoContainer & go to tabbar
                
                NSString *maxOrder=@"0";
                NSString *g_type;
                if(![resultDict objectForKey:@"girls_type"] || [resultDict objectForKey:@"girls_type"] != nil)
                    g_type=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"girls_type"]];
                else{
                    return;
                }
                if([g_type isEqualToString:@""])    return;
                
                
                
                // Get the path to the main bundle resource directory.
                
                NSString *pathsToReources = [[NSBundle mainBundle] resourcePath];
                
                NSString *yourOriginalDatabasePath = [pathsToReources stringByAppendingPathComponent:@"USER_GIRLS.sqlite"];
                
                // Create the path to the database in the Documents directory.
                
                NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                
                NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
                
                NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"USER_GIRLS.sqlite"];
                
                if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
                    
                    if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:NULL] != YES)
                        
                        NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath, yourNewDatabasePath);
                    
                }
                
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory2 = [paths objectAtIndex:0];
                
                const char *path = [[documentsDirectory2 stringByAppendingPathComponent:@"USER_GIRLS.sqlite"] UTF8String];


                if(sqlite3_open(path, &db) == SQLITE_OK) {


                    NSString *queryNS=[NSString stringWithFormat:@"SELECT max(g_order) FROM USER_GIRL WHERE type = %@ and user = '%@' group by type",g_type,[sharedInfo phone]];
                    
                    const char *query = [queryNS UTF8String];
                    sqlite3_stmt *statement;
                    sqlite3_prepare_v2(db, query, -1, &statement, NULL);
                    
                    char *error = NULL;
                    if (sqlite3_prepare_v2(db, query, -1, &statement, NULL) != SQLITE_OK) {
                        //NSLog(@"Error %@",sqlite3_errmsg(db));
                        return;
                    }

                    if (sqlite3_prepare_v2(db, query, -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            maxOrder=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                        }
                    }
                    
                    int newOrder=[maxOrder intValue] + 1;
                    queryNS=[NSString stringWithFormat:@"INSERT INTO USER_GIRL ('user','girl','type','g_order') VALUES ('%@','%@','%@', '%d')",sharedInfo.phone,phoneNumber,g_type, newOrder];
                    NSLog(@"%@",queryNS);
                    
                    sqlite3_exec(db, [queryNS UTF8String], NULL, 0, &error);
                      
                    
                    sqlite3_finalize(statement);
                } else {
                    sqlite3_close(db);
                    db = NULL;
                    
                    NSLog(@"DB OPEN ERROR: '%s'", sqlite3_errmsg(db));    
                }
                
                
                
                
                return;
            }
        }else{
            NSLog(@"Original response: %@",response);
            return;
        }
        
    }else{
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    
    
}


-(NSString *)getUserPicture:(NSString *)phoneNumber{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@",GET_USER_URL,phoneNumber]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSError *jsonError = NULL;
        NSDictionary *resultDict = [NSDictionary dictionaryWithJSONString:response error:&jsonError];
        if(!jsonError){
            NSLog(@"%@",resultDict);
            if([[resultDict objectForKey:@"code"] intValue] == 1){
                return @"";
            }else{                
                return [resultDict objectForKey:@"photo"];
            }
        }else{
            NSLog(@"Original response: %@",response);
            return @"";
        }
        
    }else{
        NSLog(@"%@",[error localizedDescription]);
        return @"";
    }
    
    
    
}



@end
