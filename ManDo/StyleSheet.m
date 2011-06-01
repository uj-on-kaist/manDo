//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "StyleSheet.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StyleSheet

/*
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)font {
  return [UIFont fontWithName:@"Helvetica" size:12];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableFont {
  return [UIFont fontWithName:@"Helvetica-Bold" size:16];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableHeaderPlainFont {
  return [UIFont fontWithName:@"Helvetica" size:120];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(UIFont*)titleFont {
  return [UIFont fontWithName:@"Helvetica-Bold" size:120];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableGroupedBackgroundColor {
  return RGBCOLOR(224, 221, 203);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableHeaderTextColor {
  return [UIColor brownColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableHeaderTintColor {
  return RGBCOLOR(224, 221, 203);
}
*/


///////////////////////////////////////////////////////////////////////////////////////////////////
/*- (UIColor*)tabTintColor {
    return RGBCOLOR(89, 111, 150);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tabBarTintColor {
    return RGBCOLOR(89, 111, 150);
}

- (UIColor*)backgroundColor {
	//return RGBCOLOR(220, 225, 235);
    return [UIColor groupTableViewBackgroundColor];
}

/////011f5b////////////////////////////////////////////////////////////////////////////////////

//#596E96

- (UIColor*)toolbarTintColor{
	return RGBCOLOR(89, 110, 150);
}

- (TTStyle*)tabStrip {
    UIColor* border = RGBCOLOR(135,135,135);
    return
    [TTReflectiveFillStyle styleWithColor:TTSTYLEVAR(tabTintColor) next:
     [TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}

- (TTStyle*)launcherButton:(UIControlState)state { 
	return 
    [TTPartStyle styleWithName:@"image" style:TTSTYLESTATE 
	 (launcherButtonImage:, state) next: 
	 [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13] 
						  color:RGBCOLOR(52,52,52) 
				minimumFontSize:13 shadowColor:RGBACOLOR(255, 255, 255,0.7) 
				   shadowOffset:CGSizeMake(2, -2) next:nil]]; 
}

-(TTStyle *)tabOverflowRight{
    return nil;
}
-(TTStyle *)tabOverflowLeft{
    return nil;
}
*/
- (UIColor*)navigationBarTintColor {
	return RGBCOLOR(70, 105, 100);
}
- (UIColor*)backgroundColor {
	return [UIColor whiteColor];
    //return RGBCOLOR(255, 255, 250);
}

-(TTStyle *)answerButton:(UIControlState)state{
    return [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
            [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 0, 1, 0) next:
             [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.4) blur:0 offset:CGSizeMake(0, 1) next:
              [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
               [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.4) blur:3 offset:CGSizeMake(0, 2) next:
                [TTBevelBorderStyle styleWithHighlight:RGBACOLOR(0,0,0,0.25) shadow:RGBACOLOR(0,0,0,0.4)
                                                 width:1 lightSource:270 next:[TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                                                                                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                                                                                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
}
- (TTStyle*)embossedButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255)
                                               color2:RGBCOLOR(216, 221, 231) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.9) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(225, 225, 225)
                                               color2:RGBCOLOR(196, 201, 221) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}

-(TTStyle *)main_tab_btn:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:2] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255)
                                               color2:RGBCOLOR(216, 221, 231) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:RGBCOLOR(70, 105, 100)
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:2] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.9) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(225, 225, 225)
                                               color2:RGBCOLOR(196, 201, 221) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}


-(TTStyle*)main_tab{
    UIColor* border =[UIColor grayColor];

    return
    [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255)
                                        color2:RGBCOLOR(216, 221, 231) next:[TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}

-(UIColor *)linkTextColor{
    return RGBCOLOR(70, 105, 100);
}
-(UIColor *)profile_bg_color{
    //[UIColor colorWithRed:234.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];
    return RGBCOLOR(234, 243, 244);
}

- (UIColor*)toolbarTintColor {
    return RGBCOLOR(108, 140, 132);
}

- (UIColor*)tabBarTintColor {
    return (UIColor*)TTSTYLE(profileHeaderView);
}

- (UIColor *)profileHeaderView{
    return RGBCOLOR(48, 44, 41);
}

@end
