//
//  Utility.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#ifndef Utility_h
#define Utility_h

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

#define debugging 1
#define verbose
#ifdef verbose
#define logMethod() NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#define errorMessage(x) NSLog(@"%@",x);
#else
#define logMethod()
#define errorMessage(x)

#endif

#define SNAP_GRAY_COLOR [UIColor colorWithRed:248 green:248 blue:248 alpha:1.0]
extern void addBottomBorder(UIView * toThisView,CGColorRef withCGColor,float size);
extern void addTopBorder(UIView * toThisView,CGColorRef withCGColor,float size);
extern void addLeftBorder(UIView * toThisView,CGColorRef withCGColor,float size);
extern void addRightBorder(UIView * toThisView,CGColorRef withCGColor,float size);





#define createUniqueMovieUrl(url)\
NSArray *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);\
NSString *docPath = [documentsDirectory objectAtIndex:0];\
NSString *videoName = [NSString stringWithFormat:@"%@.mov",[NSProcessInfo processInfo].globallyUniqueString];\
NSString *videoPath = [docPath stringByAppendingPathComponent:videoName];\
url = [NSURL fileURLWithPath:videoPath]

#define loadViewController(name) [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:name]
#define loadNibNamed(name) [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil][0]
#define dispatchAsyncMainQueue(x) dispatch_async(dispatch_get_main_queue(),^{x})
#define setRefreshController(refreshControl,target,method) \
refreshControl = [[UIRefreshControl alloc]init];\
[refreshControl addTarget:target action:@selector(method:) forControlEvents:UIControlEventValueChanged];

#define getResource(stringPathToSet,resourceName,type) \
stringPathToSet =[[NSBundle mainBundle] pathForResource:resourceName ofType:type]

#define getDocumentDirectory(docDir) \
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);\
 docDir = paths.firstObject;

// Handy bar button macros from Erica Sadun's book
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] \
initWithTitle:TITLE style:UIBarButtonItemStylePlain \
target:self action:SELECTOR]
#define BARBUTTON_TARGET(TARGET, TITLE, SELECTOR) \
[[UIBarButtonItem alloc] initWithTitle:TITLE \
style:UIBarButtonItemStylePlain target:TARGET action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] \
initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) \
[[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM \
target:TARGET action:SELECTOR]


#define basicAlertMessage(msg) UIAlertView *av = [[UIAlertView alloc] \
initWithTitle:@"Error" message:msg \
delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; \
[av show];

// mine are below
#define SETACTIONFORBUTTON(BUT,TARG,SELECTOR)\
if([BUT isKindOfClass:[UIBarButtonItem  class]]){\
    UIBarButtonItem  * b = BUT;\
    [b setTarget:TARG];\
    [b setAction:@selector(SELECTOR:)];\
    \
}else if([BUT isKindOfClass:[UIButton class]]){\
    UIButton  * b = BUT;\
    [b addTarget:TARG action:@selector(SELECTOR:) forControlEvents:UIControlEventTouchUpInside];\
    \
}else{\
    // fatal dont call this if you cant handle the heat\
    NSLog(@"You didnt handle this in setActionForButtonWithDelega...");\
    exit(0);\
}
#define  delta( initial, current,d)\
d = current;\
d.x -= initial.x;\
d.y -= initial.y;



#define SETSWIPE(SWIPEGESTURE,DELEGATE,FORTYPE) \
SWIPEGESTURE.direction = FORTYPE;\
SWIPEGESTURE.delegate = DELEGATE;\
[DELEGATE.view addGestureRecognizer:SWIPEGESTURE];


/* CUSOTMIZING CLANG TO NOT SUCK and report warnings that should be errors and vice versa
 * http://clang.llvm.org/docs/UsersManual.html#opt-fdiagnostics-show-category
 *
 * -Werror              //turn all warnings into errors
 * -Werror="WARNING"    // DONT USE DOUBLE QUOTES, but it will turn that warning into an error
 * -Wno-error="WARNING" // turns warning "WARNING" into a warning even if -Werror is specefied
 * -W"WARNING"          // enables "WARNING" dont use double quotes
 * -Wno-"WARNING"       // disabled "WARNING"
 *
 * "WARNING" -> any clang warning outputed by -fdiagnostics-show-option
 *
 * use fdiagnostics-show-category to show the class of warning
 *
#if foo
#endif foo // warning: extra tokens at end of #endif directive

#pragma clang diagnostic ignored "-Wextra-tokens"

#if foo
#endif foo // no warning

#pragma clang diagnostic pop
 ^^ will just be for the specific file!
-Wno-nullability-completeness
 *
 * */


/* USING LLDB
 http://lldb.llvm.org/lldb-gdb.html
 
****Variables****
 
frame variable // prints all variables in current stack frame
frame variable bar // prints the variable var in the current stack frame
target variable bar // prints the variable bar from the GLOBAL context
display bar // prints bar every time you stop and debug
 
****Expressions****
po EXPRESSION // will print out the expression
EXPRESSion -> any expression like [MyClass doSomething] // ex: po [content valueForKey@"url"]
 
 
 */
 

#endif /* Utility_h */
