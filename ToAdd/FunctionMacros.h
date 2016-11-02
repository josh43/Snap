#ifndef FUNCTIONMACROS_H
#define FUNCTIONMACROS_H


#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>


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

// mine are below
#define SETACTIONFORBUTTON(BUT,TARG,SELECTOR)\
if([button isKindOfClass:[UIBarButtonItem  class]]){\
    UIBarButtonItem  * b = button;\
    [b setTarget:del];\
    [b setAction:selecta];\
\
}else if([button isKindOfClass:[UIButton class]]){\
    UIButton  * b = button;\
    [b addTarget:del action:selecta forControlEvents:UIControlEventTouchUpInside];\
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

#endif /* FUNCTIONMACROS_H */
