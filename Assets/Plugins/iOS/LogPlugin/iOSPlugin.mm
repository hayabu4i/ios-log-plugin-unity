#import <Foundation/Foundation.h>
#import <os/signpost.h>

@interface iOSLogPlugin : NSObject

@end

@implementation iOSLogPlugin

+(void)createPointOfInterest:(const char*)name withMessage:(NSString*)message
{
    os_log_t log = os_log_create(name, OS_LOG_CATEGORY_POINTS_OF_INTEREST);
        
//    int itemCount = 3;
//    NSString* selectedColor = @"Red";
//    const char* pointer = "Hello world";
//
//    os_log(log, "The array contains %d items", itemCount);
//    os_log(log, "The user selected the color %@", selectedColor);
//
////     Log raw bytes from a pointer.
//    os_log(log, "%.*P", 11, pointer);
        
    os_signpost_event_emit(log, OS_SIGNPOST_ID_EXCLUSIVE, "Event", "%@", message);
}

+(void)startRegionOfInterest:(uint) id withName:(const char*) name andMessage:(NSString*)message
{
    os_log_t log = os_log_create(name, OS_LOG_CATEGORY_POINTS_OF_INTEREST);
    os_signpost_interval_begin(log, id, "Region", "%@", message);
}

+(void)endRegionOfInterest:(uint)id withName:(const char*) name
{
    os_log_t log = os_log_create(name, OS_LOG_CATEGORY_POINTS_OF_INTEREST);
    os_signpost_interval_end(log, id, "Region");
}

@end

extern "C"
{
    void _CreatePointOfInterest(const char* name, const char* message)
    {
        [iOSLogPlugin createPointOfInterest:(name) withMessage:[NSString stringWithUTF8String:message]];
    }

    void _StartRegionOfInterest(uint id, const char* name, const char* message)
    {
        [iOSLogPlugin startRegionOfInterest:(id) withName:name andMessage:[NSString stringWithUTF8String:message]];
    }

    void _EndRegionOfInterest(uint id, const char* name)
    {
        [iOSLogPlugin endRegionOfInterest:(id) withName:name];
    }
}
