//
//  ZDCFDataBaseManager.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFDataBaseManager.h"
#import "FMDB/FMDB.h"

#import "ZDCFCourseRecordModel.h"
#import "ZDCFTimeSpotModel.h"
#import "ZDCFSingleStudentModel.h"

@implementation ZDCFDataBaseManager

+ (id)getSingleton
{
    static ZDCFDataBaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZDCFDataBaseManager alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = paths[0];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"msg_cards.sqlite"];
        sharedInstance.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        //建立表的依据参照sqlite3标准数据类型
        //BUG:这里没有去重
        [sharedInstance.queue inDatabase:^(FMDatabase *db) {
            NSString *createTableSql = @"create table if not exists time_table ("
            "id integer primary key autoincrement,"
            "weekday integer,"
            "bigclass integer,"
            "ssid integer,"
            "classname text,"
            "studentname text,"
            "ishalf integer,"
            "place text,"
            "startweek integer,"
            "endweek interger"
            ")";
            [db executeUpdate:createTableSql];
        }];
    });
    return sharedInstance;
}

- (void)insertACourseRecord:(ZDCFCourseRecordModel *)model{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *insertSql = @"insert into time_table (weekday,bigclass,ssid,classname,studentname,ishalf,place,startweek,endweek) values (?,?,?,?,?,?,?,?,?)";
        [db executeUpdate:insertSql,model.weekday,model.bigclass,model.ssid,model.classname,model.studentname,[NSNumber numberWithInt:model.isHalf],model.place,model.startWeek,model.endWeek];
        
    }];
}

-(void)refreshTimeSpotModelWithCallback:(ZDCFBooleanWithDtlBlock)callback{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = @"select * FROM time_table";
        FMResultSet *s = [db executeQuery:querySql];
        while ([s next]) {
            NSUInteger weekday = [s intForColumn:@"weekday"] - 1;
            NSArray *weekdayArray = [[[ZDCFTimeSpotModel getSingleton] timeSpotArray] objectAtIndex:weekday];
            NSUInteger spotNumber = [s intForColumn:@"bigclass"] - 1;
            NSMutableSet *spotArray = [weekdayArray objectAtIndex:spotNumber];
            ZDCFCourseRecordModel *newModel = [ZDCFCourseRecordModel new];
            newModel.weekday = [NSNumber numberWithUnsignedLong:weekday];
            newModel.bigclass = [NSNumber numberWithUnsignedLong:spotNumber];
            newModel.ssid = [NSNumber numberWithInt:[s intForColumn:@"ssid"]];
            newModel.classname =[s stringForColumn:@"classname"];
            newModel.studentname = [s stringForColumn:@"studentname"];
            newModel.isHalf = [s boolForColumn:@"ishalf"];
            newModel.place = [s stringForColumn:@"place"];
            newModel.startWeek = [NSNumber numberWithInt:[s intForColumn:@"startweek"]];
            newModel.endWeek = [NSNumber numberWithInt:[s intForColumn:@"endweek"]];
            [spotArray addObject:[newModel copy]];
        }
        callback(YES,nil);
    }];
}

- (void)refreshCurrentStudentModelWithSSID:(NSNumber *)ssid callback:(ZDCFBooleanWithDtlBlock)callback{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * FROM time_table where ssid = %@",ssid];
        FMResultSet *s = [db executeQuery:querySql];
        ZDCFSingleStudentModel *singleStudent = [ZDCFSingleStudentModel getSingleton];
        singleStudent.classSet = [NSMutableSet new];
        while ([s next]) {
            ZDCFCourseRecordModel *newModel = [ZDCFCourseRecordModel new];
            newModel.weekday = [NSNumber numberWithInt:[s intForColumn:@"weekday"]];
            newModel.bigclass = [NSNumber numberWithInt:[s intForColumn:@"bigclass"]];
            newModel.ssid = [NSNumber numberWithInt:[s intForColumn:@"ssid"]];
            newModel.classname =[s stringForColumn:@"classname"];
            newModel.studentname = [s stringForColumn:@"studentname"];
            newModel.isHalf = [s boolForColumn:@"ishalf"];
            newModel.place = [s stringForColumn:@"place"];
            newModel.startWeek = [NSNumber numberWithInt:[s intForColumn:@"startweek"]];
            newModel.endWeek = [NSNumber numberWithInt:[s intForColumn:@"endweek"]];
            [singleStudent.classSet addObject:[newModel copy]];
        }
        callback(YES,nil);
    }];

}

- (void)deleteStudentWithSSID:(NSNumber *)ssid callback:(ZDCFBooleanWithDtlBlock)callback{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete FROM time_table where ssid = %@",ssid];
        [db executeUpdate:deleteSql];
        callback(YES,nil);
    }];
}

@end
