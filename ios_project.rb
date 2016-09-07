require 'xcodeproj'

# 创建目录
def createPath(path)
    if !File.directory?(path)
        Dir.mkdir(path)
    end
end

# 向文件中写入，如果不存在文件就创建文件
def writeToFile(path, content)
    # 读写模式。如果文件存在，则重写已存在的文件。如果文件不存在，则创建一个新文件用于读写
    file = File.new(path, "w+")
    file.syswrite(content)
    file.close
end

puts "\e[0;32m**********************请输入工程根路径名**********************\e[0m"
proj_path = gets.chomp()

if !File.directory?(proj_path)
    puts proj_path
    puts "\e[0;32m**********************该路径不存在！请重新执行程序！**********************\e[0m"
    exit
end

puts "\e[0;32m*************************请输入工程名************************\e[0m"
proj_name = gets.chomp()

if proj_path[proj_path.size-1,1] != "/"
    proj_path = proj_path+"/"
end

# 工程根目录
proj_path = proj_path+proj_name+"/"

puts "\e[0;32m完整工程根目录为"+proj_path+"\e[0m"

# 如果不存在该路径，则创建
createPath(proj_path)

# 创建 Example.xcodeproj工程文件，并保存
Xcodeproj::Project.new(proj_path+proj_name+".xcodeproj").save

# 打开创建的Example.xcodeproj文件
proj=Xcodeproj::Project.open(proj_path+proj_name+".xcodeproj")

# 切换目录
Dir.chdir(proj_path)

work_path = proj_path+proj_name
# 创建工作目录和测试目录
createPath(work_path)
createPath(work_path+"Tests")

# 进入工作目录
Dir.chdir(work_path)
# 创建目录结构
other_group = nil
expand_group = nil
sub_work_path_array = ["Model", "View", "ViewModel", "Controller", "Expand", "Other", "Resource"]
sub_work_path_array.each do |dir|
    createPath(dir)
    # 用绝对路径，否则可能出现问题
    new_group = proj.main_group.new_group(dir, work_path+"/"+dir)
    if dir=="Expand"
        expand_group = new_group  
    end
    if dir=="Other"
        other_group = new_group
    end
end

sub_expand_path = work_path+"/Expand/"
Dir.chdir(sub_expand_path)
# expand_group.set_source_tree('SOURCE_ROOT')
sub_expand_path_array = ["Category", "Const", "DataBase", "Macros", "Network", "Tool"]
sub_expand_path_array.each do |dir|
    createPath(dir)
    expand_group.new_group(dir, sub_expand_path+dir)
end

# other子目录
sub_other_path = work_path+"/Other/"
# 进入other子目录
Dir.chdir(sub_other_path)
sub_other_path_array = ["Base.Iproj", "Assets.xcassets"]
# 创建子目录
sub_other_path_array.each do |dir|
    createPath(dir)
end

# 在other中创建AppDelegate等相关文件
writeToFile("./AppDelegate.h","//
//  AppDelegate.h
//  TEST
//
//  Created by 施澍 on 16/9/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end")

writeToFile("./AppDelegate.m", '//
//  AppDelegate.m
//  TEST
//
//  Created by 施澍 on 16/9/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

@end')

writeToFile("./ViewController.h", "//
//  ViewController.h
//  TEST
//
//  Created by 施澍 on 16/9/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end")

writeToFile("./ViewController.m", '//
//  ViewController.m
//  TEST
//
//  Created by 施澍 on 16/9/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end'
)

writeToFile("./main.m", '//
//  main.m
//  TEST
//
//  Created by 施澍 on 16/9/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}'
)

writeToFile("./Info.plist", '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>$(EXECUTABLE_NAME)</string>
  <key>CFBundleIdentifier</key>
  <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$(PRODUCT_NAME)</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleSignature</key>
  <string>????</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSRequiresIPhoneOS</key>
  <true/>
  <key>UILaunchStoryboardName</key>
  <string>LaunchScreen</string>
  <key>UIMainStoryboardFile</key>
  <string>Main</string>
  <key>UIRequiredDeviceCapabilities</key>
  <array>
    <string>armv7</string>
  </array>
  <key>UISupportedInterfaceOrientations</key>
  <array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
  </array>
</dict>
</plist>'
)

# 进入Base.Iproj目录，创建storyboard
Dir.chdir("./Base.Iproj")
writeToFile("./LaunchScreen.storyboard", 
'<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="10117" systemVersion="15G31" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" initialViewController="01J-lp-oVM">
    <dependencies>
        <deployment identifier="iOS"/>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="10085"/>
    </dependencies>
    <scenes>
        <!--View Controller-->
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <layoutGuides>
                        <viewControllerLayoutGuide type="top" id="Llm-lL-Icb"/>
                        <viewControllerLayoutGuide type="bottom" id="xb3-aO-Qok"/>
                    </layoutGuides>
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="600" height="600"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <color key="backgroundColor" white="1" alpha="1" colorSpace="custom" customColorSpace="calibratedWhite"/>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="53" y="375"/>
        </scene>
    </scenes>
</document>'
)

writeToFile("./Main.storyboard", 
'<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="6211" systemVersion="14A298i" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" initialViewController="BYZ-38-t0r">
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="6204"/>
    </dependencies>
    <scenes>
        <!--View Controller-->
        <scene sceneID="tne-QT-ifu">
            <objects>
                <viewController id="BYZ-38-t0r" customClass="ViewController" customModuleProvider="" sceneMemberID="viewController">
                    <layoutGuides>
                        <viewControllerLayoutGuide type="top" id="y3c-jy-aDJ"/>
                        <viewControllerLayoutGuide type="bottom" id="wfy-db-euE"/>
                    </layoutGuides>
                    <view key="view" contentMode="scaleToFill" id="8bC-Xf-vdC">
                        <rect key="frame" x="0.0" y="0.0" width="600" height="600"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <color key="backgroundColor" white="1" alpha="1" colorSpace="custom" customColorSpace="calibratedWhite"/>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="dkx-z0-nzr" sceneMemberID="firstResponder"/>
            </objects>
        </scene>
    </scenes>
</document>'
)

Dir.chdir("../")
Dir.chdir("./Assets.xcassets")
createPath("./AppIcon.appiconset")
Dir.chdir("./AppIcon.appiconset")
writeToFile("./Contents.json", 
'{
  "images" : [
    {
      "idiom" : "iphone",
      "size" : "29x29",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "29x29",
      "scale" : "3x"
    },
    {
      "idiom" : "iphone",
      "size" : "40x40",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "40x40",
      "scale" : "3x"
    },
    {
      "idiom" : "iphone",
      "size" : "60x60",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "60x60",
      "scale" : "3x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}'
)

test_path = proj_path+proj_name+"Tests/"
# 进入测试目录
Dir.chdir(test_path)
writeToFile("./Info.plist", 
'<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>$(EXECUTABLE_NAME)</string>
  <key>CFBundleIdentifier</key>
  <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$(PRODUCT_NAME)</string>
  <key>CFBundlePackageType</key>
  <string>BNDL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleSignature</key>
  <string>????</string>
  <key>CFBundleVersion</key>
  <string>1</string>
</dict>
</plist>'
)

writeToFile("./"+proj_name+"Tests.m", 
'//
//  TESTTests.m
//  TESTTests
//
//  Created by 施澍 on 16/9/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TESTTests : XCTestCase

@end

@implementation TESTTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end'
) 

Dir.chdir(sub_other_path)
# 给Example分组添加文件引用
other_group.new_reference("./AppDelegate.h")
ref1=other_group.new_reference("./AppDelegate.m")
other_group.new_reference("./ViewController.h")
ref2=other_group.new_reference("./ViewController.m");
ref3=other_group.new_reference("./main.m")
ref4=other_group.new_reference("./Assets.xcassets")
ref5=other_group.new_reference("./Base.Iproj/LaunchScreen.storyboard")
ref6=other_group.new_reference("./Base.Iproj/Main.storyboard")

# 在Example分组下创建一个名字为Supporting Files的子分组，并给该子分组添加main和info.plist文件引用
other_group.new_reference("./Info.plist")

# 创建target，主要的参数 type: application dynamic_library framework static_library意思大家都懂的
# name：target名称
# platform：平台 : ios或者osx
target = proj.new_target(:application,proj_name,:ios)

# 添加target配置信息
target.build_configuration_list.set_setting('INFOPLIST_FILE', "$(SRCROOT)/"+proj_name+"/Other/Info.plist")

# target添加相关的文件引用，这样编译的时候才能引用到
target.add_file_references([ref1, ref2, ref3])
# 添加到Build Phases中的copy bundle resources 
target.add_resources([ref4, ref5, ref6])
# 设置deployment target
target.deployment_target="8.0"
# 设置BundleID
target.build_configuration_list.set_setting('PRODUCT_BUNDLE_IDENTIFIER', "EJU."+proj_name)
# 设置device只支持iphone
target.build_configuration_list.set_setting('TARGETED_DEVICE_FAMILY', '1')


Dir.chdir(test_path);
test_group=proj.main_group.new_group(proj_name+"Tests", test_path)
ref7=test_group.new_reference("./"+proj_name+"Tests.m")
test_group.new_reference("./Info.plist")


# 创建test target
test_target = proj.new_target(:unit_test_bundle, proj_name+"Tests", :ios, nil, proj.products_group)
test_refrence = test_target.product_reference
test_refrence.set_explicit_file_type('wrapper.cfbundle')
test_refrence.name = proj_name+"Tests.xctest"
test_target.add_file_references([ref7])


# 保存
proj.save


# 构建Podfile文件
writeToFile(proj_path+"/Podfile",
 "target '"+proj_name+"' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for Example
  pod 'AFNetworking', '~> 3.1.0'

  target '"+proj_name+"Tests' do
    inherit! :search_paths
    # Pods for testing
  end

end"
)

system "pod install"
puts "\e[0;32mCompleted\e[0m"
Dir.chdir(proj_path)
system "open "+proj_name+".xcworkspace"
