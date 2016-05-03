source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3'

target 'Sentry' do
  pod 'Protobuf', :path => "../../../third_party/protobuf"
  pod 'BoringSSL', :podspec => "../../../src/objective-c"
  pod 'gRPC', :path => "../../.."
  pod 'ResearchKit', '~> 1.0'
  # Depend on the generated RouteGuide library.
  pod 'Sentry', :path => '.'
end
