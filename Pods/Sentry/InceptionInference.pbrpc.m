#import "InceptionInference.pbrpc.h"

#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriter+Immediate.h>

static NSString *const kPackageName = @"tensorflow.serving";
static NSString *const kServiceName = @"InceptionService";

@implementation InceptionService

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  return (self = [super initWithHost:host packageName:kPackageName serviceName:kServiceName]);
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}


#pragma mark Classify(InceptionRequest) returns (InceptionResponse)

- (void)classifyWithRequest:(InceptionRequest *)request handler:(void(^)(InceptionResponse *response, NSError *error))handler{
  [[self RPCToClassifyWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToClassifyWithRequest:(InceptionRequest *)request handler:(void(^)(InceptionResponse *response, NSError *error))handler{
  return [self RPCToMethod:@"Classify"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[InceptionResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
@end
