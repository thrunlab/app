#import "InceptionInference.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>


@protocol InceptionService <NSObject>

#pragma mark Classify(InceptionRequest) returns (InceptionResponse)

- (void)classifyWithRequest:(InceptionRequest *)request handler:(void(^)(InceptionResponse *response, NSError *error))handler;

- (ProtoRPC *)RPCToClassifyWithRequest:(InceptionRequest *)request handler:(void(^)(InceptionResponse *response, NSError *error))handler;


@end

// Basic service implementation, over gRPC, that only does marshalling and parsing.
@interface InceptionService : ProtoService<InceptionService>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
