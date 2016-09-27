//
// Created by joshua on 7/15/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "PictureEditorView.h"
#import "TextDelegateHandler.h"
#import "ContentFinishedViewController.h"


static const float textFieldDragTime = .001f;

@implementation PictureEditorView{
    UIBezierPath * path;
    NSMutableArray * stack;
    BOOL _undo;
    float colorCutoff;
    BOOL isDraggingTextField; // if clicked on textfield for longer that .25 seconds
    CAGradientLayer *gradientLayer;
    CFAbsoluteTime startTime;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    //check thisi s called
    gradientLayer = [CAGradientLayer layer];
    //gradientLayer.frame = _colorView.bounds;
    //[self.colorView.layer addSublayer:gradientLayer];

  
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor  greenColor].CGColor,
            (__bridge id)[UIColor cyanColor].CGColor,(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor purpleColor].CGColor];

    //- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

   //UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
   //                                                                      action:@selector(tap:)];
   //tap.delegate = self;
   //tap.numberOfTapsRequired = 1;

   //[self addGestureRecognizer:tap];

    colorCutoff = (1.0f)/(float)gradientLayer.colors.count;
   /* self.colorView.layer.borderWidth = 5.0f;
    self.colorView.layer.cornerRadius = 5.0f;
    self.colorView.layer.borderColor = [UIColor whiteColor].CGColor;
*/

    gradientLayer.frame = _slider.bounds;
    // 4 total
    
    gradientLayer.frame = CGRectInset(gradientLayer.frame, -4, -4);
    
    
    gradientLayer.cornerRadius = 5.0f;
    // it will look like it has a border
    gradientLayer.masksToBounds = YES;
    gradientLayer.startPoint = CGPointMake(0.0,0.5);
    gradientLayer.endPoint = CGPointMake(1.0,0.5f);
    gradientLayer.borderWidth = 5.0f;
    gradientLayer.borderColor = [UIColor whiteColor].CGColor;
    
    
    [_slider.layer addSublayer:gradientLayer];

    _textDelegate = [[TextDelegateHandler alloc] initWithParentView:self andLabel:_textLabel];

    UIPanGestureRecognizer *panRecognizer =[[UIPanGestureRecognizer alloc]
            initWithTarget:self action:@selector(handlePan:)];
    [_textLabel addGestureRecognizer:panRecognizer];

    // wrapper = [[UIView alloc] initWithFrame:textLabel.frame];
   // [wrapper addSubview:textLabel];
   // [self addSubview:wrapper];
   // UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
   //                                                                       action:@selector(didTouchLabel:)];
   // tap.numberOfTapsRequired = 1;
   // [wrapper addGestureRecognizer:tap];



    // I believe You only want the second layer to clip to bounds, by default
   ;


    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    _textLabel.delegate = _textDelegate;



    // Initialization code
}

- (void)handlePan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        startTime = CFAbsoluteTimeGetCurrent();
        isDraggingTextField = YES;

    }else if(pan.state == UIGestureRecognizerStateEnded){
        // it ended
        isDraggingTextField = NO;


    }else{
        // it changed
        if((CFAbsoluteTimeGetCurrent() - startTime) > textFieldDragTime){
            // start moving it
            // it should be the location within the parent view...
            CGPoint point = [pan locationInView:self];
            // this is the limit in which it goes into the tab bar view and becomes
            // untouchable .. :\
            
            if(point.y > self.frame.size.height * 5/6){
                point = CGPointMake(point.x,self.frame.size.height * 5/6);
            }
            _textLabel.frame = CGRectMake(_textLabel.frame.origin.x,point.y,_textLabel.frame.size.width,_textLabel.frame.size.height);
        }

    }
}




+ (UIImage *) imageWithView:(UIView *)view
{
    //UIGraphicsBeginImageContext(view.frame.size);
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO,0.0f);
    // render the whole view layer... which include the line drawings and labels if added...

    // I am thinking vv this is what's causing the layer to look poor...
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}
-(UIColor *) getColor{

    /*      \\My pre declared code(just for clarity)
            gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor  greenColor].CGColor,
            (__bridge id)[UIColor cyanColor].CGColor,(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor purpleColor].CGColor];

            \\This below allows for easy one direction interpolation
            gradientLayer.startPoint = CGPointMake(0.5,0.0);
            gradientLayer.endPoint = CGPointMake(0.5,1.0f);

            @property (weak, nonatomic) IBOutlet UISlider *slider;

     *
     *
     */
    float interp  = _slider.value;
    // 1.0f * colors.count == index out of bounds
    if(interp >= 1.0f){
        interp = .99999f;
    }

    // think FLOOR(float * float)
    int firstColor = (int)(interp * (float)gradientLayer.colors.count);
    int secondColor = firstColor +1;


    // In case we are at the last color their is not one above it(index out of bounds)
    if(secondColor >= gradientLayer.colors.count){
        firstColor--;
        secondColor--;
    }

    // In My case the closer you are to the colorCuttoff the more the second color should have a factor
    // 0 is red .14 is orange .28 is yellow and soo on
    float firstInterp = 1.0f - (fmodf(interp,colorCutoff) / colorCutoff);
    float secondInterp = 1.0f - firstInterp;

    // make use of the gradientLayer.colors array
    const CGFloat *firstCGColor = CGColorGetComponents((__bridge CGColorRef)gradientLayer.colors[firstColor]);
    const CGFloat *secondCGColor = CGColorGetComponents((__bridge CGColorRef)gradientLayer.colors[secondColor]);

    float red = (firstCGColor[0] * firstInterp) + secondCGColor[0] * secondInterp;
    float green = (firstCGColor[1] * firstInterp) + secondCGColor[1] * secondInterp;
    float blue  = (firstCGColor[2] * firstInterp) + secondCGColor[2] * secondInterp;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    
}

- (IBAction)sliderChanged:(id)sender {
    _slider.thumbTintColor = [self getColor];
    
}


-(void) hideAllForPicture{
    //_colorView.hidden = YES;
    _slider.hidden = YES;
    
    _undoButton.hidden = YES;
}

- (void)removeAllForPicView {
    //[_colorView removeFromSuperview];
    [_slider removeFromSuperview];
    [_undoButton removeFromSuperview];
    [_enableTextButton removeFromSuperview];
    if(_textLabel.hidden){
        [_textLabel removeFromSuperview];
    }
    
}
-(void) push:(UIBezierPath *) bp withColor:(UIColor *) color{
    if(!stack){
        stack = [[NSMutableArray alloc]init];
    }
    [stack addObject:bp];
    [stack addObject:color];
}

-(void) pop{
    if(stack.count > 1){
        [stack removeLastObject];
        [stack removeLastObject];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Initialize a new path for the user gesture
    path = [UIBezierPath bezierPath];
    path.lineWidth =  4.0f;


    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    // if its in te uper 1/8  quadrant of screen send the event to the super
    [_cfvc userTouchedPoint:loc];
    if(CGRectContainsPoint(_textLabel.frame,loc)){
        startTime = CFAbsoluteTimeGetCurrent();
        isDraggingTextField = YES;

    }else {
        isDraggingTextField = NO;
        [path moveToPoint:[touch locationInView:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(isDraggingTextField){
        if((CFAbsoluteTimeGetCurrent() - startTime) > textFieldDragTime){
            // start moving it
            CGPoint point = [touch locationInView:self];
            _textLabel.frame = CGRectMake(_textLabel.frame.origin.x,point.y,_textLabel.frame.size.width,_textLabel.frame.size.height);        }

        return;
    }
    // Add new points to the path

    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    if(isDraggingTextField){
        isDraggingTextField = NO;
        return;
    }
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    // If you want to change the color do so heeere

    [self push:path.copy withColor:[self getColor].copy];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
- (IBAction)undoLast:(id)sender {
    [self pop];
    _undo = YES;
    [self setNeedsDisplay];
}
- (IBAction)textPressed:(id)sender {
    _textLabel.hidden = !_textLabel.hidden;

}

- (void)drawRect:(CGRect)rect
{
    for(int i = 0; i < stack.count; i +=2){
        [(UIColor *)stack[i+1] set];
        [(UIBezierPath *)stack[i] stroke];
    }
    if(!_undo){
        [[self getColor]  set];
        [path stroke];
        // Draw the path
    }else{
        _undo = NO;
    }


}


@end