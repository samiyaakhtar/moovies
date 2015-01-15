//
//  CustomCell.m
//  Bootcamp
//
//  Created by DX209 on 2015-01-14.
//  Copyright (c) 2015 DX209. All rights reserved.
//

#import "CustomCell.h"
@interface CustomCell()


@end

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
    self.title.minimumScaleFactor = 0.5;
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    self.title.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
